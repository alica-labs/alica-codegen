package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerJava;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IGenerator;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * the following line have to be "import de.unikassel.vs.alica.codegen.java.XtendTemplates;"
 * otherwise it must be inserted again!
 */
import de.unikassel.vs.alica.codegen.java.XtendTemplates;
import org.apache.commons.lang3.StringUtils;

import java.io.*;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;


/**
 * Code generator for Java. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerJava}.
 */
public class GeneratorImplJava extends GeneratorImpl implements IGenerator<GeneratedSourcesManagerJava> {
    private XtendTemplates xtendTemplates;
    private GeneratedSourcesManagerJava generatedSourcesManager;
    private String implPath;

    public GeneratorImplJava() {
        xtendTemplates = new XtendTemplates();
    }

    public void setGeneratedSourcesManager(GeneratedSourcesManagerJava generatedSourcesManager) {
        this.generatedSourcesManager = generatedSourcesManager;
        implPath = generatedSourcesManager.getBaseDir() + File.separator + "impl";
    }

    @Override
    public void setProtectedRegions(Map<String, String> protectedRegions) {

    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "BehaviourCreator.java").toString();
        String fileContentSource = xtendTemplates.behaviourCreator(behaviours);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void createBehaviourImpl(Behaviour behaviour) {
        String filename = StringUtils.capitalize(behaviour.getName()) + "Impl.java";
        String srcPath = Paths.get(implPath, filename).toString();
        String fileContentSource = xtendTemplates.behaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void preConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "PreCondition" + behaviour.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.preConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void preConditionCreator(Behaviour behaviour) {
        this.preConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "PreCondition" + behaviour.getId() + ".java").toString();
        String fileContentSource = xtendTemplates.preConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void runtimeConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "RunTimeCondition" + behaviour.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.runtimeConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void runtimeConditionCreator(Behaviour behaviour) {
        this.runtimeConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "RunTimeCondition" + behaviour.getId() + ".java").toString();
        String fileContentSource = xtendTemplates.runtimeConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void postConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "PostCondition" + behaviour.getPostCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.postConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void postConditionCreator(Behaviour behaviour) {
        this.postConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "PostCondition" + behaviour.getId() + ".java").toString();
        String fileContentSource = xtendTemplates.postConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createBehaviour(Behaviour behaviour) {
        this.createBehaviourImpl(behaviour);
        if (behaviour.getPreCondition() != null) {
            this.preConditionCreator(behaviour);
        }
        if (behaviour.getRuntimeCondition() != null) {
            this.runtimeConditionCreator(behaviour);
        }
        if (behaviour.getPostCondition() != null) {
            this.postConditionCreator(behaviour);
        }

        String destinationPath = cutDestinationPathToDirectory(behaviour);
        String filename = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + ".java";
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), destinationPath, filename).toString();
        String fileContentSource = xtendTemplates.behaviourCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);

        String filename2 = StringUtils.capitalize(behaviour.getName()) + ".java";
        String srcPath2 = Paths.get(generatedSourcesManager.getBaseDir(), destinationPath, filename2).toString();
        String fileContentSource2 = xtendTemplates.behaviour(behaviour);
        writeSourceFile(srcPath2, fileContentSource2);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "ConditionCreator.java").toString();
        String fileContentSource = xtendTemplates.conditionCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "ConstraintCreator.java").toString();
        String fileContentSource = xtendTemplates.constraintCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPreConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "Constraint" + behaviour.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.constraintPreConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPreCondition(Behaviour behaviour) {
        this.constraintPreConditionImpl(behaviour);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "Constraint" + behaviour.getPreCondition().getId() + ".java").toString();
        String fileContentSource = xtendTemplates.constraintPreCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintRuntimeConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "Constraint" + behaviour.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.constraintRuntimeConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintRuntimeCondition(Behaviour behaviour) {
        this.constraintRuntimeConditionImpl(behaviour);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "Constraint" + behaviour.getRuntimeCondition().getId() + ".java").toString();
        String fileContentSource = xtendTemplates.constraintRuntimeCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPostConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "Constraint" + behaviour.getPostCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.constraintPostConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPostCondition(Behaviour behaviour) {
        this.constraintPostConditionImpl(behaviour);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "Constraint" + behaviour.getPostCondition().getId() + ".java").toString();
        String fileContentSource = xtendTemplates.constraintPostCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createConstraintsForBehaviour(Behaviour behaviour) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(behaviour);

        PreCondition preCondition = behaviour.getPreCondition();
        if (preCondition != null) {
            if (preCondition.getVariables().size() > 0 || preCondition.getQuantifiers().size() > 0) {
                this.constraintPreCondition(behaviour);
            }
        }
        RuntimeCondition runtimeCondition = behaviour.getRuntimeCondition();
        if (runtimeCondition != null) {
            if (runtimeCondition.getVariables().size() > 0 || runtimeCondition.getQuantifiers().size() > 0) {
                this.constraintRuntimeCondition(behaviour);
            }
        }
        PostCondition postCondition = behaviour.getPostCondition();
        if (postCondition != null) {
            if (postCondition.getVariables().size() > 0 || postCondition.getQuantifiers().size() > 0) {
                this.constraintPostCondition(behaviour);
            }
        }

        String constraintSourcePath = Paths.get(generatedSourcesManager.getBaseDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String filename = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + "Constraints.java";
        String srcPath = Paths.get(constraintSourcePath, filename).toString();
        String fileContentSource = xtendTemplates.constraints(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanPreConditionImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "Constraint" + plan.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.constraintPlanPreConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanPreCondition(Plan plan) {
        this.constraintPlanPreConditionImpl(plan);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "Constraint" + plan.getPreCondition().getId() + ".java").toString();
        String fileContentSource = xtendTemplates.constraintPlanPreCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanRuntimeConditionImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "Constraint" + plan.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.constraintPlanRuntimeConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanRuntimeCondition(Plan plan) {
        this.constraintPlanRuntimeConditionImpl(plan);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "Constraint" + plan.getRuntimeCondition().getId() + ".java").toString();
        String fileContentSource = xtendTemplates.constraintPlanRuntimeCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanTransitionPreConditionImpl(Transition transition) {
        String srcPath = Paths.get(implPath, "Constraint" + transition.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.constraintPlanTransitionPreConditionImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanTransitionPreCondition(Plan plan, Transition transition) {
        this.constraintPlanTransitionPreConditionImpl(transition);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "Constraint" + transition.getPreCondition().getId() + ".java").toString();
        String fileContentSource = xtendTemplates.constraintPlanTransitionPreCondition(plan, transition);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createConstraintsForPlan(Plan plan) {
        String destinationPathWithoutName = cutDestinationPathToDirectory(plan);

        if (plan.getPreCondition() != null) {
            this.constraintPlanPreCondition(plan);
        }
        RuntimeCondition runtimeCondition = plan.getRuntimeCondition();
        if (runtimeCondition != null) {
            if (runtimeCondition.getVariables().size() > 0 || runtimeCondition.getQuantifiers().size() > 0) {
                this.constraintPlanRuntimeCondition(plan);
            }
        }
        List<Transition> transitions = plan.getTransitions();
        for (Transition transition: transitions) {
            PreCondition preCondition = transition.getPreCondition();
            if (preCondition != null) {
                if (preCondition.getVariables().size() > 0 || preCondition.getQuantifiers().size() > 0) {
                    this.constraintPlanTransitionPreCondition(plan, transition);
                }
            }
        }

        String constraintSourcePath = Paths.get(generatedSourcesManager.getBaseDir(), destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + "Constraints.java";
        String srcPath = Paths.get(constraintSourcePath, filename).toString();
        String fileContentSource = xtendTemplates.constraints(plan);
        writeSourceFile(srcPath, fileContentSource);

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

    private void createDomainBehaviourImpl() {
        String srcPath = Paths.get(implPath, "DomainBehaviourImpl.java").toString();
        String fileContentSource = xtendTemplates.domainBehaviourImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createDomainBehaviour() {
        this.createDomainBehaviourImpl();

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "DomainBehaviour.java").toString();
        String fileContentSource = xtendTemplates.domainBehaviour();
        writeSourceFile(srcPath, fileContentSource);
    }

    private void createDomainConditionImpl() {
        String srcPath = Paths.get(implPath, "DomainConditionImpl.java").toString();
        String fileContentSource = xtendTemplates.domainConditionImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createDomainCondition() {
        this.createDomainConditionImpl();

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "DomainCondition.java").toString();
        String fileContentSource = xtendTemplates.domainCondition();
        writeSourceFile(srcPath, fileContentSource);
    }

    private void createPlanImpl(Plan plan) {
        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + "Impl.java";
        String srcPath = Paths.get(implPath, filename).toString();
        String fileContentSource = xtendTemplates.planImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void utilityFunctionPlan(Plan plan) {
        this.utilityFunctionPlanImpl(plan);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "UtilityFunction" + plan.getId() + ".java").toString();
        String fileContentSource = xtendTemplates.utilityFunctionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void utilityFunctionPlanImpl(Plan plan) {
        String filename = "UtilityFunction" + plan.getId() + "Impl.java";
        String srcPath = Paths.get(implPath, filename).toString();
        String fileContentSource = xtendTemplates.utilityFunctionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void preConditionPlanImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "PreCondition" + plan.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.preConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void preConditionPlan(Plan plan) {
        this.preConditionPlanImpl(plan);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "PreCondition" + plan.getPreCondition().getId() + ".java").toString();
        String fileContentSource = xtendTemplates.preConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void runtimeConditionPlanImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "RunTimeCondition" + plan.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.runtimeConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void runtimeConditionPlan(Plan plan) {
        this.runtimeConditionPlanImpl(plan);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "RunTimeCondition" + plan.getRuntimeCondition().getId() + ".java").toString();
        String fileContentSource = xtendTemplates.runtimeConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void transitionPreConditionPlanImpl(Transition transition) {
        String srcPath = Paths.get(implPath, "PreCondition" + transition.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = xtendTemplates.transitionPreConditionPlanImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void transitionPreConditionPlan(State state, Transition transition) {
        this.transitionPreConditionPlanImpl(transition);

        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "PreCondition" + transition.getPreCondition().getId() + ".java").toString();
        String fileContentSource = xtendTemplates.transitionPreConditionPlan(state, transition);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createPlan(Plan plan) {
        this.createPlanImpl(plan);
        this.utilityFunctionPlan(plan);
        if (plan.getPreCondition() != null) {
            this.preConditionPlan(plan);
        }
        if (plan.getRuntimeCondition() != null) {
            this.runtimeConditionPlan(plan);
        }
        List<State> states = plan.getStates();
        for (State state: states) {
            List<Transition> transitions = state.getOutTransitions();
            for (Transition transition: transitions) {
                if (transition.getPreCondition() != null) {
                    this.transitionPreConditionPlan(state, transition);
                }
            }
        }

        String destinationPath = cutDestinationPathToDirectory(plan);
        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + ".java";
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), destinationPath, filename).toString();
        String fileContentSource = xtendTemplates.plan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String srcPath = Paths.get(generatedSourcesManager.getBaseDir(), "UtilityFunctionCreator.java").toString();
        String fileContentSource = xtendTemplates.utilityFunctionCreator(plans);
        writeSourceFile(srcPath, fileContentSource);
    }
}
