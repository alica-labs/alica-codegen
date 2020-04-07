package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerJava;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IGenerator;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * the following line have to be "import de.unikassel.vs.alica.codegen.java.XtendTemplates;"
 * otherwise it must be inserted again!
 */
import de.unikassel.vs.alica.codegen.java.CreatorTemplates;
import de.unikassel.vs.alica.codegen.java.BehaviourTemplates;
import de.unikassel.vs.alica.codegen.java.DomainTemplates;
import de.unikassel.vs.alica.codegen.java.PlanTemplates;
import de.unikassel.vs.alica.codegen.java.TransitionTemplates;
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
    private CreatorTemplates creators;
    private BehaviourTemplates behaviours;
    private DomainTemplates domain;
    private PlanTemplates plans;
    private TransitionTemplates transitions;
    private GeneratedSourcesManagerJava generatedSourcesManager;
    private String implPath;
    private String genPath;

    public GeneratorImplJava() {
        creators = new CreatorTemplates();
        behaviours = new BehaviourTemplates();
        domain = new DomainTemplates();
        plans = new PlanTemplates();
        transitions = new TransitionTemplates();
    }

    public void setGeneratedSourcesManager(GeneratedSourcesManagerJava generatedSourcesManager) {
        this.generatedSourcesManager = generatedSourcesManager;
        String baseDir = generatedSourcesManager.getBaseDir();
        implPath = Paths.get(baseDir, "impl").toString();
        genPath = Paths.get(baseDir, "gen").toString();
    }

    @Deprecated
    @Override
    public void setProtectedRegions(Map<String, String> protectedRegions) {

    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String srcPath = Paths.get(genPath, "creators", "BehaviourCreator.java").toString();
        String fileContentSource = creators.behaviourCreator(behaviours);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void createBehaviourImpl(Behaviour behaviour) {
        String filename = StringUtils.capitalize(behaviour.getName()) + "Impl.java";
        String srcPath = Paths.get(implPath, "behaviours", filename).toString();
        String fileContentSource = behaviours.behaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void preConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "PreCondition" + behaviour.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.preConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void preConditionCreator(Behaviour behaviour) {
        this.preConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(genPath, "conditions", "PreCondition" + behaviour.getId() + ".java").toString();
        String fileContentSource = behaviours.preConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void runtimeConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", "RunTimeCondition" + behaviour.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.runtimeConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void runtimeConditionCreator(Behaviour behaviour) {
        this.runtimeConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(genPath, "conditions", "RunTimeCondition" + behaviour.getId() + ".java").toString();
        String fileContentSource = behaviours.runtimeConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void postConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", "PostCondition" + behaviour.getPostCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.postConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void postConditionCreator(Behaviour behaviour) {
        this.postConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(genPath, "conditions", "PostCondition" + behaviour.getId() + ".java").toString();
        String fileContentSource = behaviours.postConditionBehaviour(behaviour);
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
        String srcPath = Paths.get(genPath, "behaviours", destinationPath, filename).toString();
        String fileContentSource = behaviours.behaviourCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);

        String filename2 = StringUtils.capitalize(behaviour.getName()) + ".java";
        String srcPath2 = Paths.get(genPath, "behaviours", destinationPath, filename2).toString();
        String fileContentSource2 = behaviours.behaviour(behaviour);
        writeSourceFile(srcPath2, fileContentSource2);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(genPath, "creators", "ConditionCreator.java").toString();
        String fileContentSource = creators.conditionCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(genPath, "creators", "ConstraintCreator.java").toString();
        String fileContentSource = creators.constraintCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPreConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", "Constraint" + behaviour.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.constraintPreConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPreCondition(Behaviour behaviour) {
        this.constraintPreConditionImpl(behaviour);

        String srcPath = Paths.get(genPath, "conditions", "Constraint" + behaviour.getPreCondition().getId() + ".java").toString();
        String fileContentSource = behaviours.constraintPreCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintRuntimeConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", "Constraint" + behaviour.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.constraintRuntimeConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintRuntimeCondition(Behaviour behaviour) {
        this.constraintRuntimeConditionImpl(behaviour);

        String srcPath = Paths.get(genPath, "conditions", "Constraint" + behaviour.getRuntimeCondition().getId() + ".java").toString();
        String fileContentSource = behaviours.constraintRuntimeCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPostConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implPath, "conditions", "Constraint" + behaviour.getPostCondition().getId() + "Impl.java").toString();
        String fileContentSource = behaviours.constraintPostConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPostCondition(Behaviour behaviour) {
        this.constraintPostConditionImpl(behaviour);

        String srcPath = Paths.get(genPath, "conditions", "Constraint" + behaviour.getPostCondition().getId() + ".java").toString();
        String fileContentSource = behaviours.constraintPostCondition(behaviour);
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

        File cstrIncPathOnDisk = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toFile();
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }

        String constraintSourcePath = Paths.get(genPath, destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String filename = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + "Constraints.java";
        String srcPath = Paths.get(constraintSourcePath, filename).toString();
        String fileContentSource = behaviours.constraints(behaviour);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanPreConditionImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "constraints", "Constraint" + plan.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.constraintPlanPreConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanPreCondition(Plan plan) {
        this.constraintPlanPreConditionImpl(plan);

        String srcPath = Paths.get(genPath, "constraints", "Constraint" + plan.getPreCondition().getId() + ".java").toString();
        String fileContentSource = plans.constraintPlanPreCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanRuntimeConditionImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "Constraint" + plan.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.constraintPlanRuntimeConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanRuntimeCondition(Plan plan) {
        this.constraintPlanRuntimeConditionImpl(plan);

        String srcPath = Paths.get(genPath, "Constraint" + plan.getRuntimeCondition().getId() + ".java").toString();
        String fileContentSource = plans.constraintPlanRuntimeCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanTransitionPreConditionImpl(Transition transition) {
        String srcPath = Paths.get(implPath, "Constraint" + transition.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = transitions.constraintPlanTransitionPreConditionImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void constraintPlanTransitionPreCondition(Plan plan, Transition transition) {
        this.constraintPlanTransitionPreConditionImpl(transition);

        String srcPath = Paths.get(genPath, "Constraint" + transition.getPreCondition().getId() + ".java").toString();
        String fileContentSource = transitions.constraintPlanTransitionPreCondition(plan, transition);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
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

        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + "Constraints.java";
        String srcPath = Paths.get(constraintsGenPath.toString(), filename).toString();
        String fileContentSource = plans.constraints(plan);
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
        String srcPath = Paths.get(implPath, "domain", "DomainBehaviourImpl.java").toString();
        String fileContentSource = domain.domainBehaviourImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createDomainBehaviour() {
        this.createDomainBehaviourImpl();

        String srcPath = Paths.get(genPath, "domain", "DomainBehaviour.java").toString();
        String fileContentSource = domain.domainBehaviour();
        writeSourceFile(srcPath, fileContentSource);
    }

    private void createDomainConditionImpl() {
        String srcPath = Paths.get(implPath, "domain", "DomainConditionImpl.java").toString();
        String fileContentSource = domain.domainConditionImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createDomainCondition() {
        this.createDomainConditionImpl();

        String srcPath = Paths.get(genPath, "domain", "DomainCondition.java").toString();
        String fileContentSource = domain.domainCondition();
        writeSourceFile(srcPath, fileContentSource);
    }

    // TODO: check why this is a comment
//    private void createPlanImpl(Plan plan) {
//        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + "Impl.java";
//        String srcPath = Paths.get(implPath, "plans", filename).toString();
//        String fileContentSource = plans.planImpl(plan);
//        if (new File(srcPath).exists()) {
//            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
//            return;
//        }
//        writeSourceFile(srcPath, fileContentSource);
//    }

    private void utilityFunctionPlan(Plan plan) {
        this.utilityFunctionPlanImpl(plan);

        String srcPath = Paths.get(genPath, "utilityfunctions", "UtilityFunction" + plan.getId() + ".java").toString();
        String fileContentSource = plans.utilityFunctionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void utilityFunctionPlanImpl(Plan plan) {
        String filename = "UtilityFunction" + plan.getId() + "Impl.java";
        String srcPath = Paths.get(implPath, "utilityfunctions", filename).toString();
        String fileContentSource = plans.utilityFunctionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void preConditionPlanImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "conditions", "PreCondition" + plan.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.preConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void preConditionPlan(Plan plan) {
        this.preConditionPlanImpl(plan);

        String srcPath = Paths.get(genPath, "conditions", "PreCondition" + plan.getPreCondition().getId() + ".java").toString();
        String fileContentSource = plans.preConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void runtimeConditionPlanImpl(Plan plan) {
        String srcPath = Paths.get(implPath, "conditions", "RunTimeCondition" + plan.getRuntimeCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.runtimeConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void runtimeConditionPlan(Plan plan) {
        this.runtimeConditionPlanImpl(plan);

        String srcPath = Paths.get(genPath, "conditions", "RunTimeCondition" + plan.getRuntimeCondition().getId() + ".java").toString();
        String fileContentSource = plans.runtimeConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
    }

    private void transitionPreConditionPlanImpl(Transition transition) {
        String srcPath = Paths.get(implPath, "conditions", "PreCondition" + transition.getPreCondition().getId() + "Impl.java").toString();
        String fileContentSource = plans.transitionPreConditionPlanImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
    }

    private void transitionPreConditionPlan(State state, Transition transition) {
        this.transitionPreConditionPlanImpl(transition);
        String srcPath = Paths.get(genPath, "conditions", "PreCondition" + transition.getPreCondition().getId() + ".java").toString();
        String fileContentSource = transitions.transitionPreConditionPlan(state, transition);
        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createPlan(Plan plan) {
        // TODO: check why this is a comment
//        String pathWithoutName = cutDestinationPathToDirectory(plan);
//        File path = Paths.get(genPath, pathWithoutName, "plans").toFile();
//        if (!path.exists()) {
//            path.mkdir();
//        }
//        this.createPlanImpl(plan);
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

        // TODO: check why this is a comment
//        String destinationPath = cutDestinationPathToDirectory(plan);
//        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + ".java";
//        String srcPath = Paths.get(genPath, destinationPath, filename).toString();
//        String fileContentSource = plans.plan(plan);
//        writeSourceFile(srcPath, fileContentSource);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String srcPath = Paths.get(genPath, "creators", "UtilityFunctionCreator.java").toString();
        String fileContentSource = creators.utilityFunctionCreator(plans);
        writeSourceFile(srcPath, fileContentSource);
    }
}
