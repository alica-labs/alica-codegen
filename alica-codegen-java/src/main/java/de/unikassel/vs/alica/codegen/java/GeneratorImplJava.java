package de.unikassel.vs.alica.codegen.java;

import com.google.googlejavaformat.java.Formatter;
import com.google.googlejavaformat.java.FormatterException;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerJava;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IGenerator;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * IF the following line is not import de.unikassel.vs.alica.codegen.java.XtendTemplates;
 * you messed it up ... great ... you made the plandesigner great again ... huge ...
 * INSERT IT
 */
import de.unikassel.vs.alica.codegen.java.XtendTemplates;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;


/**
 * Code generator for C++. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerJava}.
 * Every file that is written is formatted by the formatter that is set by setFormatter.
 */
public class GeneratorImplJava extends GeneratorImpl implements IGenerator<GeneratedSourcesManagerJava> {
    private XtendTemplates xtendTemplates;
    private GeneratedSourcesManagerJava generatedSourcesManager;

    public GeneratorImplJava() {
        xtendTemplates = new XtendTemplates();
    }

    public void setGeneratedSourcesManager(GeneratedSourcesManagerJava generatedSourcesManager) {
        this.generatedSourcesManager = generatedSourcesManager;
    }

    @Override
    public void setProtectedRegions(Map<String, String> protectedRegions) {

    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "BehaviourCreator.java").toString();
        String fileContentSource = xtendTemplates.behaviourCreator(behaviours);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createBehaviour(Behaviour behaviour) {
        String destinationPath = cutDestinationPathToDirectory(behaviour);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), destinationPath, behaviour.getName() + behaviour.getId() + ".java").toString();
        String fileContentSource = xtendTemplates.behaviourCondition(behaviour, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);

        String srcPath2 = Paths.get(generatedSourcesManager.getBaseDir(), destinationPath, behaviour.getName()+ ".java").toString();
        String fileContentSource2 = xtendTemplates.behaviour(behaviour);
        writeSourceFile(srcPath2, fileContentSource2);
        formatFile(srcPath2);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "ConditionCreator.java").toString();
        String fileContentSource = xtendTemplates.conditionCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "ConstraintCreator.java").toString();
        String fileContentSource = xtendTemplates.constraintCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createConstraintsForPlan(Plan plan) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(plan);
        String constraintHeaderPath = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toString();
        File cstrIncPathOnDisk = new File(constraintHeaderPath);
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }

        String constraintSourcePath = Paths.get(generatedSourcesManager.getBaseDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String srcPath = Paths.get(constraintSourcePath, plan.getName() + plan.getId() + "Constraints.java").toString();
        String fileContentSource = xtendTemplates.constraints(plan, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);

        for (State inPlan: plan.getStates()) {
            try {
                LineNumberReader lineNumberReader = new LineNumberReader(new FileReader(srcPath));
                while (lineNumberReader.ready()) {
                    if (lineNumberReader.readLine().contains("// State: " + inPlan.getName())) {
                        generatedSourcesManager.putLineForModelElement(inPlan.getId(), lineNumberReader.getLineNumber());
                        break;
                    }
                }
                lineNumberReader.close();
            } catch (IOException e) {
                LOG.error("Could not open/read lines for " + srcPath, e);
            }
        }
    }

    @Override
    public void createConstraintsForBehaviour(Behaviour behaviour) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(behaviour);
        String constraintHeaderPath = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toString();
        File cstrIncPathOnDisk = new File(constraintHeaderPath);
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }

        String constraintSourcePath = Paths.get(generatedSourcesManager.getBaseDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String srcPath = Paths.get(constraintSourcePath, behaviour.getName() + behaviour.getId() + "Constraints.java").toString();
        String fileContentSource = xtendTemplates.constraints(behaviour, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createPlan(Plan plan) {
        String destinationPath = cutDestinationPathToDirectory(plan);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), destinationPath, plan.getName() + plan.getId() + ".java").toString();
        String fileContentSource = xtendTemplates.plan(plan, getActiveConstraintCodeGenerator());
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "UtilityFunctionCreator.java").toString();
        String fileContentSource = xtendTemplates.utilityFunctionCreator(plans);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createDomainCondition() {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "DomainCondition.java").toString();
        String fileContentSource = xtendTemplates.domainCondition();
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createDomainBehaviour() {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "DomainBehaviour.java").toString();
        String fileContentSource = xtendTemplates.domainBehaviour();
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private String readFile(String path) {
        StringBuilder stringBuilder = new StringBuilder();
        try (Stream stream = Files.lines(Paths.get(path), StandardCharsets.UTF_8)) {
            stream.forEach(s -> stringBuilder.append(s).append("\n"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stringBuilder.toString();
    }

    private void writeFile(String path, String content) {
        try (
                Writer writer = new BufferedWriter(new OutputStreamWriter(
                        new FileOutputStream(path),
                        StandardCharsets.UTF_8
                ))
        ) {
            writer.write(content);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Calls the executable found by the formatter attribute on the file found by filename.
     * It is assumed that the executable is clang-format or has the same CLI as clang-format.
     *
     * @param fileName
     */
    @Override
    public void formatFile(String fileName) {
        String sourceString = readFile(fileName);
        try {
            String formattedSource = new Formatter().formatSource(sourceString);
            writeFile(fileName, formattedSource);
        } catch (FormatterException e) {
            LOG.error("An error occurred while formatting generated sources", e);
            e.printStackTrace();
        }
    }
}
