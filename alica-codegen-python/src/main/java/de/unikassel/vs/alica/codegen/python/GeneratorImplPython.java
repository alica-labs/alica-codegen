package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerPython;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IGenerator;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * the following line have to be "import de.unikassel.vs.alica.codegen.python.XtendTemplates;"
 * otherwise it must be inserted again!
 */
import de.unikassel.vs.alica.codegen.python.XtendTemplates;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

/**
 * Code generator for Python. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerPython}.
 */
public class GeneratorImplPython extends GeneratorImpl implements IGenerator<GeneratedSourcesManagerPython>  {
    private XtendTemplates xtendTemplates;
    private GeneratedSourcesManagerPython generatedSourcesManager;
    private String implDir;
    private String baseDir;

    public GeneratorImplPython() {
        xtendTemplates = new XtendTemplates();
    }

    public void setGeneratedSourcesManager(GeneratedSourcesManagerPython generatedSourcesManager) {
        this.generatedSourcesManager = generatedSourcesManager;
        baseDir = generatedSourcesManager.getBaseDir();
        implDir = baseDir + File.separator + "impl";
    }

    @Override
    public void setProtectedRegions(Map<String, String> protectedRegions) {

    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String srcPath = Paths.get(baseDir, "behaviour_creator.py").toString();
        String fileContentSource = xtendTemplates.behaviourCreator(behaviours);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void createBehaviourImpl(Behaviour behaviour) {
        String filename = StringUtils.lowerCase(behaviour.getName()) + "_impl.py";
        String srcPath = Paths.get(implDir, filename).toString();
        String fileContentSource = xtendTemplates.behaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void preConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implDir, "pre_condition_" + behaviour.getPreCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.preConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void preConditionCreator(Behaviour behaviour) {
        this.preConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(baseDir, "pre_condition_" + behaviour.getId() + ".py").toString();
        String fileContentSource = xtendTemplates.preConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void runtimeConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implDir, "runtime_condition_" + behaviour.getRuntimeCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.runtimeConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void runtimeConditionCreator(Behaviour behaviour) {
        this.runtimeConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(baseDir, "runtime_condition_" + behaviour.getId() + ".py").toString();
        String fileContentSource = xtendTemplates.runtimeConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void postConditionBehaviourImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implDir, "post_condition_" + behaviour.getPostCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.postConditionBehaviourImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void postConditionCreator(Behaviour behaviour) {
        this.postConditionBehaviourImpl(behaviour);

        String srcPath = Paths.get(baseDir, "post_condition_" + behaviour.getId() + ".py").toString();
        String fileContentSource = xtendTemplates.postConditionBehaviour(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
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
        String filename = StringUtils.lowerCase(behaviour.getName()) + "_" + behaviour.getId() + ".py";
        String srcPath = Paths.get(baseDir, destinationPath, filename).toString();
        String fileContentSource = xtendTemplates.behaviourCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);

        String filename2 = StringUtils.lowerCase(behaviour.getName()) + ".py";
        String srcPath2 = Paths.get(baseDir, destinationPath, filename2).toString();
        String fileContentSource2 = xtendTemplates.behaviour(behaviour);
        writeSourceFile(srcPath2, fileContentSource2);
        formatFile(srcPath2);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(baseDir, "condition_creator.py").toString();
        String fileContentSource = xtendTemplates.conditionCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String srcPath = Paths.get(baseDir, "constraint_creator.py").toString();
        String fileContentSource = xtendTemplates.constraintCreator(plans, behaviours, conditions);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPreConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implDir, "constraint_" + behaviour.getPreCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.constraintPreConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPreCondition(Behaviour behaviour) {
        this.constraintPreConditionImpl(behaviour);

        String srcPath = Paths.get(baseDir, "constraint_" + behaviour.getPreCondition().getId() + ".py").toString();
        String fileContentSource = xtendTemplates.constraintPreCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintRuntimeConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implDir, "constraint_" + behaviour.getRuntimeCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.constraintRuntimeConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintRuntimeCondition(Behaviour behaviour) {
        this.constraintRuntimeConditionImpl(behaviour);

        String srcPath = Paths.get(baseDir, "constraint_" + behaviour.getRuntimeCondition().getId() + ".py").toString();
        String fileContentSource = xtendTemplates.constraintRuntimeCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPostConditionImpl(Behaviour behaviour) {
        String srcPath = Paths.get(implDir, "constraint_" + behaviour.getPostCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.constraintPostConditionImpl(behaviour);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPostCondition(Behaviour behaviour) {
        this.constraintPostConditionImpl(behaviour);

        String srcPath = Paths.get(baseDir, "constraint_" + behaviour.getPostCondition().getId() + ".py").toString();
        String fileContentSource = xtendTemplates.constraintPostCondition(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createConstraintsForBehaviour(Behaviour behaviour) {
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

        String destinationPathWithoutName = cutDestinationPathToDirectory(behaviour);
        String constraintHeaderPath = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toString();
        File cstrIncPathOnDisk = new File(constraintHeaderPath);
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }

        String constraintSourcePath = Paths.get(baseDir, destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String filename = StringUtils.lowerCase(behaviour.getName()) + "_" + behaviour.getId() + "_constraints.py";
        String srcPath = Paths.get(constraintSourcePath, filename).toString();
        String fileContentSource = xtendTemplates.constraints(behaviour);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanPreConditionImpl(Plan plan) {
        String srcPath = Paths.get(implDir, "constraint_" + plan.getPreCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.constraintPlanPreConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanPreCondition(Plan plan) {
        this.constraintPlanPreConditionImpl(plan);

        String srcPath = Paths.get(baseDir, "constraint_" + plan.getPreCondition().getId() + ".py").toString();
        String fileContentSource = xtendTemplates.constraintPlanPreCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanRuntimeConditionImpl(Plan plan) {
        String srcPath = Paths.get(implDir, "constraint_" + plan.getRuntimeCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.constraintPlanRuntimeConditionImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanRuntimeCondition(Plan plan) {
        this.constraintPlanRuntimeConditionImpl(plan);

        String srcPath = Paths.get(baseDir, "constraint_" + plan.getRuntimeCondition().getId() + ".py").toString();
        String fileContentSource = xtendTemplates.constraintPlanRuntimeCondition(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanTransitionPreConditionImpl(Transition transition) {
        String srcPath = Paths.get(implDir, "constraint_" + transition.getPreCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.constraintPlanTransitionPreConditionImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void constraintPlanTransitionPreCondition(Plan plan, Transition transition) {
        this.constraintPlanTransitionPreConditionImpl(transition);

        String srcPath = Paths.get(baseDir, "constraint_" + transition.getPreCondition().getId() + ".py").toString();
        String fileContentSource = xtendTemplates.constraintPlanTransitionPreCondition(plan, transition);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createConstraintsForPlan(Plan plan) {
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

        String destinationPathWithoutName = cutDestinationPathToDirectory(plan);
        String constraintHeaderPath = Paths.get(generatedSourcesManager.getIncludeDir(),
                destinationPathWithoutName, "constraints").toString();
        File cstrIncPathOnDisk = new File(constraintHeaderPath);
        if (!cstrIncPathOnDisk.exists()) {
            cstrIncPathOnDisk.mkdir();
        }

        String constraintSourcePath = Paths.get(baseDir, destinationPathWithoutName, "constraints").toString();
        File cstrSrcPathOnDisk = new File(constraintSourcePath);
        if (!cstrSrcPathOnDisk.exists()) {
            cstrSrcPathOnDisk.mkdir();
        }

        String filename = StringUtils.lowerCase(plan.getName()) + "_" + plan.getId() + "_constraints.py";
        String srcPath = Paths.get(constraintSourcePath, filename).toString();
        String fileContentSource = xtendTemplates.constraints(plan);
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

    private void createDomainBehaviourImpl() {
        String srcPath = Paths.get(implDir, "domain_behaviour_impl.py").toString();
        String fileContentSource = xtendTemplates.domainBehaviourImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createDomainBehaviour() {
        this.createDomainBehaviourImpl();

        String srcPath = Paths.get(baseDir, "domain_behaviour.py").toString();
        String fileContentSource = xtendTemplates.domainBehaviour();
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void createDomainConditionImpl() {
        String srcPath = Paths.get(implDir, "domain_condition_impl.py").toString();
        String fileContentSource = xtendTemplates.domainConditionImpl();
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createDomainCondition() {
        this.createDomainConditionImpl();

        String srcPath = Paths.get(baseDir, "domain_condition.py").toString();
        String fileContentSource = xtendTemplates.domainCondition();
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void createPlanImpl(Plan plan) {
        String filename = StringUtils.lowerCase(plan.getName()) + "_" + plan.getId() + "_impl.py";
        String srcPath = Paths.get(implDir, filename).toString();
        String fileContentSource = xtendTemplates.planImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void utilityFunctionPlan(Plan plan) {
        this.utilityFunctionPlanImpl(plan);

        String srcPath = Paths.get(baseDir, "utility_function_" + plan.getId() + ".py").toString();
        String fileContentSource = xtendTemplates.utilityFunctionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void utilityFunctionPlanImpl(Plan plan) {
        String filename = "utility_function_" + plan.getId() + "_impl.py";
        String srcPath = Paths.get(implDir, filename).toString();
        String fileContentSource = xtendTemplates.utilityFunctionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void preConditionPlanImpl(Plan plan) {
        String srcPath = Paths.get(implDir, "pre_condition_" + plan.getPreCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.preConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void preConditionPlan(Plan plan) {
        this.preConditionPlanImpl(plan);

        String srcPath = Paths.get(baseDir, "pre_condition_" + plan.getPreCondition().getId() + ".py").toString();
        String fileContentSource = xtendTemplates.preConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void runtimeConditionPlanImpl(Plan plan) {
        String srcPath = Paths.get(implDir, "runtime_condition_" + plan.getRuntimeCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.runtimeConditionPlanImpl(plan);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void runtimeConditionPlan(Plan plan) {
        this.runtimeConditionPlanImpl(plan);

        String srcPath = Paths.get(baseDir, "runtime_condition_" + plan.getRuntimeCondition().getId() + ".py").toString();
        String fileContentSource = xtendTemplates.runtimeConditionPlan(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void transitionPreConditionPlanImpl(Transition transition) {
        String srcPath = Paths.get(implDir, "pre_condition_" + transition.getPreCondition().getId() + "_impl.py").toString();
        String fileContentSource = xtendTemplates.transitionPreConditionPlanImpl(transition);
        if (new File(srcPath).exists()) {
            LOG.debug("File \"" + srcPath + "\" already exists and is not overwritten");
            return;
        }
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    private void transitionPreConditionPlan(State state, Transition transition) {
        this.transitionPreConditionPlanImpl(transition);

        String srcPath = Paths.get(baseDir, "pre_condition_" + transition.getPreCondition().getId() + ".py").toString();
        String fileContentSource = xtendTemplates.transitionPreConditionPlan(state, transition);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
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
        String filename = StringUtils.lowerCase(plan.getName()) + "_" + plan.getId() + ".py";
        String srcPath = Paths.get(baseDir, destinationPath, filename).toString();
        String fileContentSource = xtendTemplates.plan(plan);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String srcPath = Paths.get(baseDir, "utility_function_creator.py").toString();
        String fileContentSource = xtendTemplates.utilityFunctionCreator(plans);
        writeSourceFile(srcPath, fileContentSource);
        formatFile(srcPath);
    }

    @Override
    public void formatFile(String fileName) {
//        // pip install yapf
//
//        URL formatStyle = GeneratorImplPython.class.getResource(".style.yapf");
//        String command = this.formatter +
//                " --style=" + formatStyle +
//                " " + fileName;
//        try {
//            Runtime.getRuntime().exec(command).waitFor();
//        } catch (IOException | InterruptedException e) {
//            LOG.error("An error occurred while formatting generated sources", e);
//            throw new RuntimeException(e);
//        }
    }
}
