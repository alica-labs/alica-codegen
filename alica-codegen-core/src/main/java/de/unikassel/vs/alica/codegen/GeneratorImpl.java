package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.codegen.plugin.IPlugin;
import de.unikassel.vs.alica.codegen.plugin.PluginManager;
import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public abstract class GeneratorImpl {
    protected static final Logger LOG = LogManager.getLogger(GeneratorImpl.class);

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

    /**
     * calls createConstraintsForPlan on each plan
     *
     * @param plans
     */
    public void createConstraints(List<Plan> plans) {
        for (Plan plan : plans) {
            createConstraintsForPlan(plan);
        }

    }

    abstract public void createConstraintsForPlan(Plan plan);

    /**
     * calls createPlan for each plan
     *
     * @param plans list of all plans to generate (usually this should be all plans in workspace)
     */
    public void createPlans(List<Plan> plans) {
        for (Plan plan : plans) {
            createPlan(plan);
        }
    }

    abstract public void createPlan(Plan plan);

    protected String cutDestinationPathToDirectory(AbstractPlan plan) {
        String destinationPath = plan.getRelativeDirectory();
        if (destinationPath.lastIndexOf('.') > destinationPath.lastIndexOf(File.separator)) {
            destinationPath = destinationPath.substring(0, destinationPath.lastIndexOf(File.separator) + 1);
        }
        return destinationPath;
    }

    /**
     * This returns the {@link IConstraintCodeGenerator} of the active newCondition plugin.
     * TODO This maybe a candidate for a default method.
     *
     * @return
     */
    public IConstraintCodeGenerator getActiveConstraintCodeGenerator() {
        IPlugin<?> defaultPlugin = PluginManager.getInstance().getDefaultPlugin();
        if (defaultPlugin == null) {
            return null;
        }
        return PluginManager.getInstance().getDefaultPlugin().getConstraintCodeGenerator();
    }
}
