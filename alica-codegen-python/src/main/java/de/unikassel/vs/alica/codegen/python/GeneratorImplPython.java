package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerPython;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IGenerator;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * The following lines must be the following. If they are not, they must be re-inserted.
 *
 * import de.unikassel.vs.alica.codegen.python.CreatorTemplates;
 * import de.unikassel.vs.alica.codegen.python.BehaviourTemplates;
 * import de.unikassel.vs.alica.codegen.python.DomainTemplates;
 * import de.unikassel.vs.alica.codegen.python.PlanTemplates;
 * import de.unikassel.vs.alica.codegen.python.TransitionTemplates;
 */
import de.unikassel.vs.alica.codegen.python.CreatorTemplates;
import de.unikassel.vs.alica.codegen.python.BehaviourTemplates;
import de.unikassel.vs.alica.codegen.python.DomainTemplates;
import de.unikassel.vs.alica.codegen.python.PlanTemplates;
import de.unikassel.vs.alica.codegen.python.TransitionTemplates;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

/**
 * Code generator for Python. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerPython}.
 */
public class GeneratorImplPython extends GeneratorImpl implements IGenerator<GeneratedSourcesManagerPython>  {

    public GeneratorImplPython() {
        creators = new CreatorTemplates();
        behaviours = new BehaviourTemplates();
        domain = new DomainTemplates();
        plans = new PlanTemplates();
        transitions = new TransitionTemplates();
    }

    public void setGeneratedSourcesManager(GeneratedSourcesManagerPython generatedSourcesManager) {
        this.generatedSourcesManager = generatedSourcesManager;
        String baseDir = generatedSourcesManager.getBaseDir();
        super.setBaseDir(baseDir);
    }

    @Deprecated
    @Override
    public void setProtectedRegions(Map<String, String> protectedRegions) {

    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String filename = "behaviour_creator.py";
        this.createBehaviourCreator(filename, behaviours);
    }

    public void createBehaviourImpl(Behaviour behaviour) {
        String filename = StringUtils.lowerCase(behaviour.getName()) + "_impl.py";
        this.createBehaviourImpl(filename, behaviour);
    }

    public void preConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "pre_condition_" + behaviour.getPreCondition().getId() + "_impl.py";
        this.preConditionBehaviourImpl(filename, behaviour);
    }

    public void preConditionCreator(Behaviour behaviour) {
        String filename = "pre_condition_" + behaviour.getId() + ".py";
        this.preConditionCreator(filename, behaviour);
    }

    public void runtimeConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "runtime_condition_" + behaviour.getRuntimeCondition().getId() + "_impl.py";
        this.runtimeConditionBehaviourImpl(filename, behaviour);
    }

    public void runtimeConditionCreator(Behaviour behaviour) {
        String filename = "runtime_condition_" + behaviour.getId() + ".py";
        this.runtimeConditionCreator(filename, behaviour);
    }

    public void postConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "post_condition_" + behaviour.getPostCondition().getId() + "_impl.py";
        this.postConditionBehaviourImpl(filename, behaviour);
    }

    public void postConditionCreator(Behaviour behaviour) {
        String filename = "post_condition_" + behaviour.getId() + ".py";
        this.postConditionCreator(filename, behaviour);
    }

    public void createBehaviours(Behaviour behaviour) {
        super.createBehaviours(behaviour);
        String filename = StringUtils.lowerCase(behaviour.getName()) + "_" + behaviour.getId() + ".py";
        this.createBehaviourCondition(filename, behaviour);
        String filename2 = StringUtils.lowerCase(behaviour.getName()) + ".py";
        this.createBehaviour(filename2, behaviour);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filename = "condition_creator.py";
        this.createConditionCreator(filename, plans, behaviours, conditions);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filename = "constraint_creator.py";
        this.createConstraintCreator(filename, plans, behaviours, conditions);
    }

    public void constraintPreCondition(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getPreCondition().getId() + ".py";
        this.constraintPreCondition(filename, behaviour);
    }

    public void constraintPreConditionImpl(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getPreCondition().getId() + "_impl.py";
        this.constraintPreConditionImpl(filename, behaviour);
    }

    public void constraintRuntimeCondition(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getRuntimeCondition().getId() + ".py";
        this.constraintRuntimeCondition(filename, behaviour);
    }

    public void constraintRuntimeConditionImpl(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getRuntimeCondition().getId() + "_impl.py";
        this.constraintRuntimeConditionImpl(filename, behaviour);
    }

    public void constraintPostCondition(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getPostCondition().getId() + ".py";
        this.constraintPostCondition(filename, behaviour);
    }

    public void constraintPostConditionImpl(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getPostCondition().getId() + "_impl.py";
        this.constraintPostConditionImpl(filename, behaviour);
    }

    public void createConstraintsForBehaviour(Behaviour behaviour) {
        super.createConstraintsForBehaviour(behaviour);
        String filename = StringUtils.lowerCase(behaviour.getName()) + "_" + behaviour.getId() + "_constraints.py";
        this.createBehaviourConstraints(filename, behaviour);
    }

    public void constraintPlanPreCondition(Plan plan) {
        this.constraintPlanPreConditionImpl(plan);
        String filename = "constraint_" + plan.getPreCondition().getId() + ".py";
        this.constraintPlanPreCondition(filename, plan);
    }

    public void constraintPlanPreConditionImpl(Plan plan) {
        String filename = "constraint_" + plan.getPreCondition().getId() + "_impl.py";
        this.constraintPlanPreConditionImpl(filename, plan);
    }

    public void constraintPlanRuntimeCondition(Plan plan) {
        this.constraintPlanRuntimeConditionImpl(plan);
        String filename = "constraint_" + plan.getRuntimeCondition().getId() + ".py";
        this.constraintPlanRuntimeCondition(filename, plan);
    }

    public void constraintPlanRuntimeConditionImpl(Plan plan) {
        String filename = "constraint_" + plan.getRuntimeCondition().getId() + "_impl.py";
        this.constraintPlanRuntimeConditionImpl(filename, plan);
    }

    public void constraintPlanTransitionPreCondition(Plan plan, Transition transition) {
        this.constraintPlanTransitionPreConditionImpl(transition);
        String filename = "constraint_" + transition.getPreCondition().getId() + ".py";
        this.constraintPlanTransitionPreCondition(filename, plan, transition);
    }

    public void constraintPlanTransitionPreConditionImpl(Transition transition) {
        String filename = "constraint_" + transition.getPreCondition().getId() + "_impl.py";
        this.constraintPlanTransitionPreConditionImpl(filename, transition);
    }

    public void createConstraintsForPlan(Plan plan) {
        super.createConstraintsForPlan(plan);
        String filename = StringUtils.lowerCase(plan.getName()) + "_" + plan.getId() + "_constraints.py";
        this.createPlanConstraints(filename, plan);
        this.readConstraintsForPlan(filename, plan);
    }

    @Override
    public void createDomainBehaviour() {
        this.createDomainBehaviourImpl();
        String filename = "domain_behaviour.py";
        this.createDomainBehaviour(filename);
    }

    private void createDomainBehaviourImpl() {
        String filename = "domain_behaviour_impl.py";
        this.createDomainBehaviourImpl(filename);
    }

    @Override
    public void createDomainCondition() {
        this.createDomainConditionImpl();
        String filename = "domain_condition.py";
        this.createDomainCondition(filename);
    }

    private void createDomainConditionImpl() {
        String filename = "domain_condition_impl.py";
        this.createDomainConditionImpl(filename);
    }

    public void utilityFunctionPlan(Plan plan) {
        String filename = "utility_function_" + plan.getId() + ".py";
        this.utilityFunctionPlan(filename, plan);
    }

    public void utilityFunctionPlanImpl(Plan plan) {
        String filename = "utility_function_" + plan.getId() + "_impl.py";
        this.utilityFunctionPlanImpl(filename, plan);
    }

    public void preConditionPlan(Plan plan) {
        String filename = "pre_condition_" + plan.getPreCondition().getId() + ".py";
        this.preConditionPlan(filename, plan);
    }

    public void preConditionPlanImpl(Plan plan) {
        String filename = "pre_condition_" + plan.getPreCondition().getId() + "_impl.py";
        this.preConditionPlanImpl(filename, plan);
    }

    public void runtimeConditionPlan(Plan plan) {
        String filename = "runtime_condition_" + plan.getRuntimeCondition().getId() + ".py";
        this.runtimeConditionPlan(filename, plan);
    }

    public void runtimeConditionPlanImpl(Plan plan) {
        String filename = "runtime_condition_" + plan.getRuntimeCondition().getId() + "_impl.py";
        this.runtimeConditionPlanImpl(filename, plan);
    }

    public void transitionPreConditionPlan(State state, Transition transition) {
        String filename = "pre_condition_" + transition.getPreCondition().getId() + ".py";
        this.transitionPreConditionPlan(filename, state, transition);
    }

    public void transitionPreConditionPlanImpl(Transition transition) {
        String filename = "pre_condition_" + transition.getPreCondition().getId() + "_impl.py";
        this.transitionPreConditionPlanImpl(filename, transition);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String filename = "utility_function_creator.py";
        this.createUtilityFunctionCreator(filename, plans);
    }

    @Override
    public void createFolder(Path folder) {
        super.createFolder(folder);
        createInitFile(folder.toString());
    }

    private void createInitFile(String destinationDir) {
        File filePath = Paths.get(destinationDir, "__init__.py").toFile();
        if (filePath.exists()) {
            return;
        }
        writeSourceFile(filePath.toString(), "");
    }
}
