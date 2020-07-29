package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.codegen.java.GeneratorImplJava;
import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

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

    public CodegeneratorJava() {
        this.generator = new GeneratorImplJava();
    }

    /**
     * Generates source files for all ALICA plans and behaviours in workspace.
     */
    // TODO: To be reviewed and maybe adapted, because of MVC pattern adaption.
    public void generate() {
        try {
            if (Files.notExists(Paths.get(destination))) {
                Files.createDirectories(Paths.get(destination));
            }
        } catch (IOException e) {
            LOG.error("Could not find expression validator path! ", e);
            throw new RuntimeException(e);
        }

        generator.createDomainBehaviour();
        generator.createDomainCondition();

        generator.createUtilityFunctionCreator(plans);
        generator.createBehaviourCreator(behaviours);
        generator.createConditionCreator(plans, behaviours, conditions);
        generator.createConstraintCreator(plans, behaviours, conditions);

        generator.createConstraints(plans);
        generator.createPlans(plans);

        for (Behaviour behaviour : behaviours) {
            generator.createBehaviours(behaviour);
            generator.createConstraintsForBehaviour(behaviour);
        }
        LOG.info("Generated all files successfully");
    }
}
