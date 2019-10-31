package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.codegen.cpp.GeneratorImplCpp;
import de.unikassel.vs.alica.codegen.cpp.parser.CommentsLexer;
import de.unikassel.vs.alica.codegen.cpp.parser.CommentsParser;
import de.unikassel.vs.alica.codegen.cpp.parser.ProtectedRegionsVisitor;
import de.unikassel.vs.alica.codegen.plugin.PluginManager;
import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

/**
 * General Code Generator. It manages calling the correct {@link IGenerator} implementation
 * and serves as a simple way of generating code for the rest of the application.
 * If you want to generate a file just call {@link Codegenerator#generate(AbstractPlan)}
 * or {@link Codegenerator#generate()} to generate all files.
 * <p>
 * Do not cache this object.
 * A new instance should be created for every use or at least after creating a new ALICA object.
 */
public class CodegeneratorCpp extends Codegenerator {

    public CodegeneratorCpp(
            List<Plan> plans,
            List<Behaviour> behaviours,
            List<Condition> conditions,
            String formatter,
            String destination,
            GeneratedSourcesManagerCpp generatedSourcesManager
    ) {
        super(new GeneratorImplCpp(),
                plans,
                behaviours,
                conditions,
                formatter,
                destination,
                generatedSourcesManager
        );
    }

    /**
     * Generates source files for all ALICA plans and behaviours in workspace.
     */
    // TODO: To be reviewed and maybe adapted, because of MVC pattern adaption.
    public void generate() {
        ProtectedRegionsVisitor protectedRegionsVisitor = new ProtectedRegionsVisitor();
        try {
            if (Files.notExists(Paths.get(codeGenerationDestination))) {
                Files.createDirectories(Paths.get(codeGenerationDestination));
            }
            Files.walk(Paths.get(codeGenerationDestination)).filter(e -> {
                String fileName = e.getFileName().toString();
                return fileName.endsWith(".h") || fileName.endsWith(".cpp");
            }).forEach(e -> {
                try {
                    visit(protectedRegionsVisitor, e);
                    currentFile.set(e.toString());
                } catch (IOException e1) {
                    LOG.error("Could not parse existing source file " + e, e1);
                    throw new RuntimeException(e1);
                }
            });
        } catch (IOException e) {
            LOG.error("Could not find expression validator path! ", e);
            throw new RuntimeException(e);
        }

        PluginManager.getInstance().getDefaultPlugin().setProtectedRegions(protectedRegionsVisitor.getProtectedRegions());
        languageSpecificGenerator.setProtectedRegions(protectedRegionsVisitor.getProtectedRegions());

        languageSpecificGenerator.createDomainBehaviour();
        languageSpecificGenerator.createDomainCondition();

        languageSpecificGenerator.createUtilityFunctionCreator(plans);
        languageSpecificGenerator.createBehaviourCreator(behaviours);
        languageSpecificGenerator.createConditionCreator(plans, behaviours, conditions);
        languageSpecificGenerator.createConstraintCreator(plans, behaviours, conditions);

        languageSpecificGenerator.createConstraints(plans);
        languageSpecificGenerator.createPlans(plans);

        for (Behaviour behaviour : behaviours) {
            languageSpecificGenerator.createBehaviour(behaviour);
            languageSpecificGenerator.createConstraintsForBehaviour(behaviour);
        }
        LOG.info("Generated all files successfully");
    }

    private void visit(ProtectedRegionsVisitor protectedRegionsVisitor, Path e) throws IOException {
        CommentsLexer lexer = new CommentsLexer(CharStreams.fromPath(e));
        CommonTokenStream commonTokenStream = new CommonTokenStream(lexer);
        CommentsParser parser = new CommentsParser(commonTokenStream);
        CommentsParser.All_textContext all_textContext = parser.all_text();
        protectedRegionsVisitor.visit(all_textContext);
    }

    public void collectProtectedRegions(List<File> filesToParse) {
        ProtectedRegionsVisitor protectedRegionsVisitor = new ProtectedRegionsVisitor();
        for (File genFile : filesToParse) {
            try {
                if (genFile.exists()) {
                    visit(protectedRegionsVisitor, genFile.toPath());
                }
            } catch (IOException e1) {
                LOG.error("Could not parse existing source file " + genFile.getAbsolutePath(), e1);
                throw new RuntimeException(e1);
            }
        }
        PluginManager.getInstance().getDefaultPlugin().setProtectedRegions(protectedRegionsVisitor.getProtectedRegions());
        languageSpecificGenerator.setProtectedRegions(protectedRegionsVisitor.getProtectedRegions());
    }
}
