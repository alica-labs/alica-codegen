package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.codegen.plugin.PluginManager;
import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

public class GeneratorImpl implements IGenerator {
    protected static final Logger LOG = LogManager.getLogger(GeneratorImpl.class);

    protected GeneratedSourcesManager generatedSourcesManager;
    protected String formatter;

    @Override
    public void setGeneratedSourcesManager(GeneratedSourcesManager generatedSourcesManager) {
        this.generatedSourcesManager = generatedSourcesManager;
    }

    /**
     * Small helper for writing source files
     *
     * @param filePath    filePath to write to
     * @param fileContent the content to write
     */
    protected void writeSourceFile(String filePath, String fileContent) {
        try {

            if (Files.notExists(Paths.get(filePath).getParent())) {
                Files.createDirectories(Paths.get(filePath).getParent());
            }
            Files.write(Paths.get(filePath), fileContent.getBytes(StandardCharsets.UTF_8));
        } catch (IOException e) {
            LOG.error("Couldn't write source file "
                    + filePath + " with content size " + fileContent
                    .getBytes(StandardCharsets.UTF_8).length, e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public void setProtectedRegions(Map<String, String> protectedRegions) {

    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {

    }

    @Override
    public void createBehaviour(Behaviour behaviour) {

    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {

    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {

    }

    /**
     * calls createConstraintsForPlan on each plan
     *
     * @param plans
     */
    @Override
    public void createConstraints(List<Plan> plans) {
        for (Plan plan : plans) {
            createConstraintsForPlan(plan);
        }

    }

    @Override
    public void createConstraintsForPlan(Plan plan) {

    }

    @Override
    public void createConstraintsForBehaviour(Behaviour behaviour) {

    }

    /**
     * calls createPlan for each plan
     *
     * @param plans list of all plans to generate (usually this should be all plans in workspace)
     */
    @Override
    public void createPlans(List<Plan> plans) {
        for (Plan plan : plans) {
            createPlan(plan);
        }
    }

    @Override
    public void createPlan(Plan plan) {

    }

    protected String cutDestinationPathToDirectory(AbstractPlan plan) {
        String destinationPath = plan.getRelativeDirectory();
        if (destinationPath.lastIndexOf('.') > destinationPath.lastIndexOf(File.separator)) {
            destinationPath = destinationPath.substring(0, destinationPath.lastIndexOf(File.separator) + 1);
        }
        return destinationPath;
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {

    }

    @Override
    public void createDomainCondition() {

    }

    @Override
    public void createDomainBehaviour() {

    }

    @Override
    public void setFormatter(String formatter) {
        this.formatter = formatter;
    }

    @Override
    public void formatFile(String fileName) {

    }

    /**
     * This returns the {@link IConstraintCodeGenerator} of the active newCondition plugin.
     * TODO This maybe a candidate for a default method.
     *
     * @return
     */
    @Override
    public IConstraintCodeGenerator getActiveConstraintCodeGenerator() {
        return PluginManager.getInstance().getDefaultPlugin().getConstraintCodeGenerator();
    }
}
