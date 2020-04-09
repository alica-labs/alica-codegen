package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.codegen.plugin.IPlugin;
import de.unikassel.vs.alica.codegen.plugin.PluginManager;
import de.unikassel.vs.alica.codegen.templates.*;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public abstract class GeneratorImpl {
    protected static final Logger LOG = LogManager.getLogger(GeneratorImpl.class);

    public GeneratedSourcesManager generatedSourcesManager;

    public ICreatorTemplates creators;
    public IBehaviourTemplates behaviours;
    public IDomainTemplates domain;
    public IPlanTemplates plans;
    public ITransitionTemplates transitions;

    private String implPath;
    private String genPath;

    protected void setBaseDir(String baseDir) {
        implPath = Paths.get(baseDir, "impl").toString();
        genPath = Paths.get(baseDir, "gen").toString();
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

    protected String cutDestinationPathToDirectory(AbstractPlan plan) {
        String destinationPath = plan.getRelativeDirectory();
        if (destinationPath.lastIndexOf('.') > destinationPath.lastIndexOf(File.separator)) {
            destinationPath = destinationPath.substring(0, destinationPath.lastIndexOf(File.separator) + 1);
        }
        return destinationPath;
    }

    public void createBehaviours(Behaviour behaviour) {
        this.createBehaviourImpl(behaviour);
        if (behaviour.getPreCondition() != null) {
            this.preConditionCreator(behaviour);
            this.preConditionBehaviourImpl(behaviour);
        }
        if (behaviour.getRuntimeCondition() != null) {
            this.runtimeConditionCreator(behaviour);
            this.runtimeConditionBehaviourImpl(behaviour);
        }
        if (behaviour.getPostCondition() != null) {
            this.postConditionCreator(behaviour);
            this.postConditionBehaviourImpl(behaviour);
        }
    }

    abstract public void createBehaviourImpl(Behaviour behaviour);

    abstract public void preConditionCreator(Behaviour behaviour);

    abstract public void preConditionBehaviourImpl(Behaviour behaviour);

    abstract public void runtimeConditionCreator(Behaviour behaviour);

    abstract public void runtimeConditionBehaviourImpl(Behaviour behaviour);

    abstract public void postConditionCreator(Behaviour behaviour);

    abstract public void postConditionBehaviourImpl(Behaviour behaviour);

    public void createConstraintsForBehaviour(Behaviour behaviour) {
        PreCondition preCondition = behaviour.getPreCondition();
        if (preCondition != null) {
            if (preCondition.getVariables().size() > 0 || preCondition.getQuantifiers().size() > 0) {
                this.constraintPreCondition(behaviour);
                this.constraintPreConditionImpl(behaviour);
            }
        }
        RuntimeCondition runtimeCondition = behaviour.getRuntimeCondition();
        if (runtimeCondition != null) {
            if (runtimeCondition.getVariables().size() > 0 || runtimeCondition.getQuantifiers().size() > 0) {
                this.constraintRuntimeCondition(behaviour);
                this.constraintRuntimeConditionImpl(behaviour);
            }
        }
        PostCondition postCondition = behaviour.getPostCondition();
        if (postCondition != null) {
            if (postCondition.getVariables().size() > 0 || postCondition.getQuantifiers().size() > 0) {
                this.constraintPostCondition(behaviour);
                this.constraintPostConditionImpl(behaviour);
            }
        }

        String destinationPathWithoutName = cutDestinationPathToDirectory(behaviour);

        File cstrIncPathOnDisk = Paths.get(implPath, destinationPathWithoutName, "constraints").toFile();
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }
    }

    protected abstract void constraintPostConditionImpl(Behaviour behaviour);

    protected abstract void constraintPostCondition(Behaviour behaviour);

    protected abstract void constraintRuntimeConditionImpl(Behaviour behaviour);

    protected abstract void constraintRuntimeCondition(Behaviour behaviour);

    protected abstract void constraintPreConditionImpl(Behaviour behaviour);

    protected abstract void constraintPreCondition(Behaviour behaviour);

    public void createConstraintsForPlan(Plan plan) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(plan);
        File constraintsImplPath = Paths.get(implPath, destinationPathWithoutName, "constraints").toFile();
        if (!constraintsImplPath.exists()) {
            constraintsImplPath.mkdir();
        }
        File constraintsGenPath = Paths.get(genPath, destinationPathWithoutName, "constraints").toFile();
        if (!constraintsGenPath.exists()) {
            constraintsGenPath.mkdir();
        }

        if (plan.getPreCondition() != null) {
            this.constraintPlanPreCondition(plan);
            this.constraintPlanPreConditionImpl(plan);
        }
        RuntimeCondition runtimeCondition = plan.getRuntimeCondition();
        if (runtimeCondition != null) {
            if (runtimeCondition.getVariables().size() > 0 || runtimeCondition.getQuantifiers().size() > 0) {
                this.constraintPlanRuntimeCondition(plan);
                this.constraintPlanRuntimeConditionImpl(plan);
            }
        }
        List<Transition> transitions = plan.getTransitions();
        for (Transition transition: transitions) {
            PreCondition preCondition = transition.getPreCondition();
            if (preCondition != null) {
                if (preCondition.getVariables().size() > 0 || preCondition.getQuantifiers().size() > 0) {
                    this.constraintPlanTransitionPreCondition(plan, transition);
                    this.constraintPlanTransitionPreConditionImpl(transition);
                }
            }
        }
    }

    public void readConstraintsForPlan(String filename, Plan plan) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(plan);
        File constraintsGenPath = Paths.get(genPath, destinationPathWithoutName, "constraints").toFile();
        String srcPath = Paths.get(constraintsGenPath.toString(), filename).toString();

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

    protected abstract void constraintPlanTransitionPreConditionImpl(Transition transition);

    protected abstract void constraintPlanTransitionPreCondition(Plan plan, Transition transition);

    protected abstract void constraintPlanRuntimeConditionImpl(Plan plan);

    protected abstract void constraintPlanRuntimeCondition(Plan plan);

    protected abstract void constraintPlanPreConditionImpl(Plan plan);

    protected abstract void constraintPlanPreCondition(Plan plan);

    public void createPlan(Plan plan) {
        this.utilityFunctionPlan(plan);
        this.utilityFunctionPlanImpl(plan);

        if (plan.getPreCondition() != null) {
            this.preConditionPlan(plan);
        }

        if (plan.getRuntimeCondition() != null) {
            this.runtimeConditionPlan(plan);
            this.runtimeConditionPlanImpl(plan);
        }

        List<State> states = plan.getStates();
        for (State state: states) {
            List<Transition> transitions = state.getOutTransitions();
            for (Transition transition: transitions) {
                if (transition.getPreCondition() != null) {
                    this.transitionPreConditionPlan(state, transition);
                    this.transitionPreConditionPlanImpl(transition);
                }
            }
        }
    }

    protected abstract void runtimeConditionPlanImpl(Plan plan);

    protected abstract void transitionPreConditionPlanImpl(Transition transition);

    protected abstract void transitionPreConditionPlan(State state, Transition transition);

    protected abstract void runtimeConditionPlan(Plan plan);

    protected abstract void preConditionPlan(Plan plan);

    protected abstract void utilityFunctionPlanImpl(Plan plan);

    protected abstract void utilityFunctionPlan(Plan plan);

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








    public void createBehaviourCreator(String filename, List<Behaviour> behaviours) {
        String srcPath = Paths.get(genPath, "creators", filename).toString();
        String fileContentSource = creators.behaviourCreator(behaviours);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createBehaviourImpl(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "behaviours", filename).toString();
        String fileContentSource = behaviours.behaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void preConditionBehaviourImpl(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(implPath, filename).toString();
        String fileContentSource = behaviours.preConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void preConditionCreator(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(genPath, "conditions", filename).toString();
        String fileContentSource = behaviours.preConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void runtimeConditionBehaviourImpl(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", filename).toString();
        String fileContentSource = behaviours.runtimeConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void runtimeConditionCreator(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(genPath, "conditions", filename).toString();
        String fileContentSource = behaviours.runtimeConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void postConditionBehaviourImpl(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", filename).toString();
        String fileContentSource = behaviours.postConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void postConditionCreator(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(genPath, "conditions", filename).toString();
        String fileContentSource = behaviours.postConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createConditionCreator(String filename, List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(genPath, "creators", filename).toString();
        String fileContentSource = creators.conditionCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createConstraintCreator(String filename, List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(genPath, "creators", filename).toString();
        String fileContentSource = creators.constraintCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPreConditionImpl(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", filename).toString();
        String fileContentSource = behaviours.constraintPreConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPreCondition(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(genPath, "conditions", filename).toString();
        String fileContentSource = behaviours.constraintPreCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintRuntimeConditionImpl(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", filename).toString();
        String fileContentSource = behaviours.constraintRuntimeConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintRuntimeCondition(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(genPath, "conditions", filename).toString();
        String fileContentSource = behaviours.constraintRuntimeCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPostConditionImpl(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", filename).toString();
        String fileContentSource = behaviours.constraintPostConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPostCondition(String filename, Behaviour behaviour) {
        String srcPath = Paths.get(genPath, "conditions", filename).toString();
        String fileContentSource = behaviours.constraintPostCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPlanPreConditionImpl(String filename, Plan plan) {
        String srcPath = Paths.get(implPath, "constraints", filename).toString();
        String fileContentSource = plans.constraintPlanPreConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPlanPreCondition(String filename, Plan plan) {
        String srcPath = Paths.get(genPath, "constraints", filename).toString();
        String fileContentSource = plans.constraintPlanPreCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPlanRuntimeConditionImpl(String filename, Plan plan) {
        String srcPath = Paths.get(implPath, filename).toString();
        String fileContentSource = plans.constraintPlanRuntimeConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPlanRuntimeCondition(String filename, Plan plan) {
        String srcPath = Paths.get(genPath, filename).toString();
        String fileContentSource = plans.constraintPlanRuntimeCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPlanTransitionPreConditionImpl(String filename, Transition transition) {
        String srcPath = Paths.get(implPath, filename).toString();
        String fileContentSource = transitions.constraintPlanTransitionPreConditionImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void constraintPlanTransitionPreCondition(String filename, Plan plan, Transition transition) {
        String srcPath = Paths.get(genPath, filename).toString();
        String fileContentSource = transitions.constraintPlanTransitionPreCondition(plan, transition);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createDomainBehaviourImpl(String filename) {
        String srcPath = Paths.get(implPath, "domain", filename).toString();
        String fileContentSource = domain.domainBehaviourImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createDomainBehaviour(String filename) {
        String srcPath = Paths.get(genPath, "domain", filename).toString();
        String fileContentSource = domain.domainBehaviour();
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createDomainConditionImpl(String filename) {
        String srcPath = Paths.get(implPath, "domain", filename).toString();
        String fileContentSource = domain.domainConditionImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createDomainCondition(String filename) {
        String srcPath = Paths.get(genPath, "domain", filename).toString();
        String fileContentSource = domain.domainCondition();
        writeSourceFile(srcPath, fileContentSource);
    }

    public void utilityFunctionPlan(String filename, Plan plan) {
        String srcPath = Paths.get(genPath, "utilityfunctions", filename).toString();
        String fileContentSource = plans.utilityFunctionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void utilityFunctionPlanImpl(String filename, Plan plan) {
        String srcPath = Paths.get(implPath, "utilityfunctions", filename).toString();
        String fileContentSource = plans.utilityFunctionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void preConditionPlanImpl(String filename, Plan plan) {
        String srcPath = Paths.get(implPath, "conditions", filename).toString();
        String fileContentSource = plans.preConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void preConditionPlan(String filename, Plan plan) {
        String srcPath = Paths.get(genPath, "conditions", filename).toString();
        String fileContentSource = plans.preConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void runtimeConditionPlanImpl(String filename, Plan plan) {
        String srcPath = Paths.get(implPath, "conditions", filename).toString();
        String fileContentSource = plans.runtimeConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void runtimeConditionPlan(String filename, Plan plan) {
        String srcPath = Paths.get(genPath, "conditions", filename).toString();
        String fileContentSource = plans.runtimeConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void transitionPreConditionPlanImpl(String filename, Transition transition) {
        String srcPath = Paths.get(implPath, "conditions", filename).toString();
        String fileContentSource = transitions.transitionPreConditionPlanImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    public void transitionPreConditionPlan(String filename, State state, Transition transition) {
        String srcPath = Paths.get(genPath, "conditions", filename).toString();
        String fileContentSource = transitions.transitionPreConditionPlan(state, transition);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createUtilityFunctionCreator(String filename, List<Plan> plans) {
        String srcPath = Paths.get(genPath, "creators", filename).toString();
        String fileContentSource = creators.utilityFunctionCreator(plans);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createBehaviourCondition(String filename, Behaviour behaviour) {
        String destinationPath = cutDestinationPathToDirectory(behaviour);
        String srcPath = Paths.get(genPath, "behaviours", destinationPath, filename).toString();
        String fileContentSource = behaviours.behaviourCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createBehaviour(String filename, Behaviour behaviour) {
        String destinationPath = cutDestinationPathToDirectory(behaviour);
        String srcPath = Paths.get(genPath, "behaviours", destinationPath, filename).toString();
        String fileContentSource = behaviours.behaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createBehaviourConstraints(String filename, Behaviour behaviour) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(behaviour);

        String constraintSourcePath = Paths.get(genPath, destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String srcPath = Paths.get(constraintSourcePath, filename).toString();
        String fileContentSource = behaviours.constraints(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    public void createPlanConstraints(String filename, Plan plan) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(plan);
        File constraintsGenPath = Paths.get(genPath, destinationPathWithoutName, "constraints").toFile();

        String srcPath = Paths.get(constraintsGenPath.toString(), filename).toString();
        String fileContentSource = plans.constraints(plan);
        writeSourceFile(srcPath, fileContentSource);
    }
}
