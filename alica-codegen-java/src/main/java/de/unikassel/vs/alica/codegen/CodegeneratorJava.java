package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.codegen.java.GeneratorImplJava;
import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;

import java.io.IOException;
import java.nio.file.Files;
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
public class CodegeneratorJava extends Codegenerator {

    public CodegeneratorJava(
            List<Plan> plans,
            List<Behaviour> behaviours,
            List<Condition> conditions,
            String destination,
            GeneratedSourcesManagerJava generatedSourcesManager
    ) {
        super(new GeneratorImplJava(),
                plans,
                behaviours,
                conditions,
                null,
                destination,
                generatedSourcesManager
        );
    }

    /**
     * Generates source files for all ALICA plans and behaviours in workspace.
     */
    // TODO: To be reviewed and maybe adapted, because of MVC pattern adaption.
    public void generate() {
        try {
            if (Files.notExists(Paths.get(codeGenerationDestination))) {
                Files.createDirectories(Paths.get(codeGenerationDestination));
            }

        } catch (IOException e) {
            LOG.error("Could not find expression validator path! ", e);
            throw new RuntimeException(e);
        }

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
}
