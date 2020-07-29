package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.codegen.GeneratedSourcesManager;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerPython;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IGenerator;
import de.unikassel.vs.alica.codegen.python.templates.*;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
import org.apache.commons.lang3.StringUtils;

import java.util.List;

/**
 * The following lines must be the following. If they are not, they must be re-inserted.
 *
 * import de.unikassel.vs.alica.codegen.python.templates.*;
 */
import de.unikassel.vs.alica.codegen.python.templates.*;

/**
 * Code generator for Python. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerPython}.
 */
public class GeneratorImplPython extends GeneratorImpl implements IGenerator  {
    private final CodegenHelperPython codegenHelper;

    public GeneratorImplPython() {
        codegenHelper = new CodegenHelperPython();
        codegenHelper.setCreatorTemplates(new CreatorTemplates());
        codegenHelper.setBehaviourTemplates(new BehaviourTemplates());
        codegenHelper.setDomainTemplates(new DomainTemplates());
        codegenHelper.setPlanTemplates(new PlanTemplates());
        codegenHelper.setTransitionTemplates(new TransitionTemplates());
    }

    public void setGeneratedSourcesManager(GeneratedSourcesManager generatedSourcesManager) {
        GeneratedSourcesManagerPython generatedSourcesManagerPython = (GeneratedSourcesManagerPython) generatedSourcesManager;

        codegenHelper.setGeneratedSourcesManager(generatedSourcesManagerPython);
        String baseDir = generatedSourcesManagerPython.getSourcePath();
        codegenHelper.setBaseDir(baseDir);
    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String filename = "behaviour_creator.py";
        codegenHelper.createBehaviourCreator(filename, behaviours);
    }

    public void createBehaviourImpl(Behaviour behaviour) {
        String filename = StringUtils.lowerCase(behaviour.getName()) + "_impl.py";
        codegenHelper.createBehaviourImpl(filename, behaviour);
    }

    public void preConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "pre_condition_" + behaviour.getPreCondition().getId() + "_impl.py";
        codegenHelper.preConditionBehaviourImpl(filename, behaviour);
    }

    public void preConditionCreator(Behaviour behaviour) {
        String filename = "pre_condition_" + behaviour.getId() + ".py";
        codegenHelper.preConditionCreator(filename, behaviour);
    }

    public void runtimeConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "runtime_condition_" + behaviour.getRuntimeCondition().getId() + "_impl.py";
        codegenHelper.runtimeConditionBehaviourImpl(filename, behaviour);
    }

    public void runtimeConditionCreator(Behaviour behaviour) {
        String filename = "runtime_condition_" + behaviour.getId() + ".py";
        codegenHelper.runtimeConditionCreator(filename, behaviour);
    }

    public void postConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "post_condition_" + behaviour.getPostCondition().getId() + "_impl.py";
        codegenHelper.postConditionBehaviourImpl(filename, behaviour);
    }

    public void postConditionCreator(Behaviour behaviour) {
        String filename = "post_condition_" + behaviour.getId() + ".py";
        codegenHelper.postConditionCreator(filename, behaviour);
    }

    public void createBehaviours(Behaviour behaviour) {
        super.createBehaviours(behaviour);
        String filename = StringUtils.lowerCase(behaviour.getName()) + "_" + behaviour.getId() + ".py";
        codegenHelper.createBehaviourCondition(filename, behaviour);
        String filename2 = StringUtils.lowerCase(behaviour.getName()) + ".py";
        codegenHelper.createBehaviour(filename2, behaviour);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filename = "condition_creator.py";
        codegenHelper.createConditionCreator(filename, plans, behaviours, conditions);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filename = "constraint_creator.py";
        codegenHelper.createConstraintCreator(filename, plans, behaviours, conditions);
    }

    public void constraintPreCondition(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getPreCondition().getId() + ".py";
        codegenHelper.constraintPreCondition(filename, behaviour);
    }

    public void constraintPreConditionImpl(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getPreCondition().getId() + "_impl.py";
        codegenHelper.constraintPreConditionImpl(filename, behaviour);
    }

    public void constraintRuntimeCondition(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getRuntimeCondition().getId() + ".py";
        codegenHelper.constraintRuntimeCondition(filename, behaviour);
    }

    public void constraintRuntimeConditionImpl(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getRuntimeCondition().getId() + "_impl.py";
        codegenHelper.constraintRuntimeConditionImpl(filename, behaviour);
    }

    public void constraintPostCondition(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getPostCondition().getId() + ".py";
        codegenHelper.constraintPostCondition(filename, behaviour);
    }

    public void constraintPostConditionImpl(Behaviour behaviour) {
        String filename = "constraint_" + behaviour.getPostCondition().getId() + "_impl.py";
        codegenHelper.constraintPostConditionImpl(filename, behaviour);
    }

    public void createConstraintsForBehaviour(Behaviour behaviour) {
        super.createConstraintsForBehaviour(behaviour);
        String filename = StringUtils.lowerCase(behaviour.getName()) + "_" + behaviour.getId() + "_constraints.py";
        codegenHelper.createBehaviourConstraints(filename, behaviour);
    }

    public void constraintPlanPreCondition(Plan plan) {
        this.constraintPlanPreConditionImpl(plan);
        String filename = "constraint_" + plan.getPreCondition().getId() + ".py";
        codegenHelper.constraintPlanPreCondition(filename, plan);
    }

    public void constraintPlanPreConditionImpl(Plan plan) {
        String filename = "constraint_" + plan.getPreCondition().getId() + "_impl.py";
        codegenHelper.constraintPlanPreConditionImpl(filename, plan);
    }

    public void constraintPlanRuntimeCondition(Plan plan) {
        this.constraintPlanRuntimeConditionImpl(plan);
        String filename = "constraint_" + plan.getRuntimeCondition().getId() + ".py";
        codegenHelper.constraintPlanRuntimeCondition(filename, plan);
    }

    public void constraintPlanRuntimeConditionImpl(Plan plan) {
        String filename = "constraint_" + plan.getRuntimeCondition().getId() + "_impl.py";
        codegenHelper.constraintPlanRuntimeConditionImpl(filename, plan);
    }

    public void constraintPlanTransitionPreCondition(Plan plan, Transition transition) {
        this.constraintPlanTransitionPreConditionImpl(transition);
        String filename = "constraint_" + transition.getPreCondition().getId() + ".py";
        codegenHelper.constraintPlanTransitionPreCondition(filename, plan, transition);
    }

    public void constraintPlanTransitionPreConditionImpl(Transition transition) {
        String filename = "constraint_" + transition.getPreCondition().getId() + "_impl.py";
        codegenHelper.constraintPlanTransitionPreConditionImpl(filename, transition);
    }

    public void createConstraintsForPlan(Plan plan) {
        super.createConstraintsForPlan(plan);
        String filename = StringUtils.lowerCase(plan.getName()) + "_" + plan.getId() + "_constraints.py";
        codegenHelper.createPlanConstraints(filename, plan);
        codegenHelper.readConstraintsForPlan(filename, plan);
    }

    @Override
    public void createDomainBehaviour() {
        this.createDomainBehaviourImpl();
        String filename = "domain_behaviour.py";
        codegenHelper.createDomainBehaviour(filename);
    }

    private void createDomainBehaviourImpl() {
        String filename = "domain_behaviour_impl.py";
        codegenHelper.createDomainBehaviourImpl(filename);
    }

    @Override
    public void createDomainCondition() {
        this.createDomainConditionImpl();
        String filename = "domain_condition.py";
        codegenHelper.createDomainCondition(filename);
    }

    private void createDomainConditionImpl() {
        String filename = "domain_condition_impl.py";
        codegenHelper.createDomainConditionImpl(filename);
    }

    public void utilityFunctionPlan(Plan plan) {
        String filename = "utility_function_" + plan.getId() + ".py";
        codegenHelper.utilityFunctionPlan(filename, plan);
    }

    public void utilityFunctionPlanImpl(Plan plan) {
        String filename = "utility_function_" + plan.getId() + "_impl.py";
        codegenHelper.utilityFunctionPlanImpl(filename, plan);
    }

    public void preConditionPlan(Plan plan) {
        String filename = "pre_condition_" + plan.getPreCondition().getId() + ".py";
        codegenHelper.preConditionPlan(filename, plan);
    }

    public void preConditionPlanImpl(Plan plan) {
        String filename = "pre_condition_" + plan.getPreCondition().getId() + "_impl.py";
        codegenHelper.preConditionPlanImpl(filename, plan);
    }

    public void runtimeConditionPlan(Plan plan) {
        String filename = "runtime_condition_" + plan.getRuntimeCondition().getId() + ".py";
        codegenHelper.runtimeConditionPlan(filename, plan);
    }

    public void runtimeConditionPlanImpl(Plan plan) {
        String filename = "runtime_condition_" + plan.getRuntimeCondition().getId() + "_impl.py";
        codegenHelper.runtimeConditionPlanImpl(filename, plan);
    }

    public void transitionPreConditionPlan(State state, Transition transition) {
        String filename = "pre_condition_" + transition.getPreCondition().getId() + ".py";
        codegenHelper.transitionPreConditionPlan(filename, state, transition);
    }

    public void transitionPreConditionPlanImpl(Transition transition) {
        String filename = "pre_condition_" + transition.getPreCondition().getId() + "_impl.py";
        codegenHelper.transitionPreConditionPlanImpl(filename, transition);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String filename = "utility_function_creator.py";
        codegenHelper.createUtilityFunctionCreator(filename, plans);
    }
}
