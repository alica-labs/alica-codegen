package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.util.Collections;
import java.util.List;

public class Codegenerator implements ICodegenerator {
    static final Logger LOG = LogManager.getLogger(Codegenerator.class);

    final IGenerator languageSpecificGenerator;
    final String codeGenerationDestination;
    final GeneratedSourcesManager generatedSourcesManager;

    public StringProperty currentFile = new SimpleStringProperty();
    List<Plan> plans;
    List<Behaviour> behaviours;
    List<Condition> conditions;

    public Codegenerator(IGenerator generatorImpl,
                         List<Plan> plans,
                         List<Behaviour> behaviours,
                         List<Condition> conditions,
                         String formatter,
                         String destination,
                         GeneratedSourcesManager generatedSourcesManager
    ) {
        languageSpecificGenerator = generatorImpl;
        languageSpecificGenerator.setGeneratedSourcesManager(generatedSourcesManager);
        languageSpecificGenerator.setFormatter(formatter);
        codeGenerationDestination = destination;
        this.generatedSourcesManager = generatedSourcesManager;

        this.plans = plans;
        Collections.sort(plans, new PlanElementComparator());
        this.behaviours = behaviours;
        Collections.sort(behaviours, new PlanElementComparator());
        this.conditions = conditions;
        Collections.sort(conditions, new PlanElementComparator());
    }

    @Override
    public void generate() {

    }

    /**
     * (Re)Generates source files for the given object.
     * If the given object is an instance of {@link Plan} or {@link Behaviour}.
     *
     * @param abstractPlan
     */
    @Override
    public void generate(AbstractPlan abstractPlan) {
        if (abstractPlan instanceof Plan) {
            generate((Plan) abstractPlan);
        } else if (abstractPlan instanceof Behaviour) {
            generate((Behaviour) abstractPlan);
        } else {
            LOG.error("Nothing to generate for something else than a plan or behaviour!");
        }
    }

    @Override
    public void generate(Plan plan) {
        List<File> generatedFiles = generatedSourcesManager.getGeneratedConditionFilesForPlan(plan);
        generatedFiles.addAll(generatedSourcesManager.getGeneratedConstraintFilesForPlan(plan));
        collectProtectedRegions(generatedFiles);
        languageSpecificGenerator.createConstraintsForPlan(plan);
        languageSpecificGenerator.createPlan(plan);
        languageSpecificGenerator.createConditionCreator(plans, behaviours, conditions);
        languageSpecificGenerator.createUtilityFunctionCreator(plans);
    }

    @Override
    public void generate(Behaviour behaviour) {
        List<File> generatedFiles = generatedSourcesManager.getGeneratedFilesForBehaviour(behaviour);
        generatedFiles.addAll(generatedSourcesManager.getGeneratedConstraintFilesForBehaviour(behaviour));
        collectProtectedRegions(generatedFiles);
        languageSpecificGenerator.createBehaviourCreator(behaviours);
        languageSpecificGenerator.createConstraintsForBehaviour(behaviour);
        languageSpecificGenerator.createBehaviour(behaviour);
    }

    @Override
    public void collectProtectedRegions(List<File> filesToParse) {

    }
}
