package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.codegen.*;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * The following lines must be the following. If they are not, they must be re-inserted.
 *
 * import de.unikassel.vs.alica.codegen.java.templates.*;
 */
import de.unikassel.vs.alica.codegen.java.templates.*;

import org.apache.commons.lang3.StringUtils;

import java.util.List;


/**
 * Code generator for Java. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerJava}.
 */
public class GeneratorImplJava extends GeneratorImpl implements IGenerator {
    private final CodegenHelper codegenHelper;

    public GeneratorImplJava() {
        codegenHelper = new CodegenHelper();
        codegenHelper.setCreatorTemplates(new CreatorTemplates());
        codegenHelper.setBehaviourTemplates(new BehaviourTemplates());
        codegenHelper.setDomainTemplates(new DomainTemplates());
        codegenHelper.setPlanTemplates(new PlanTemplates());
        codegenHelper.setTransitionTemplates(new TransitionTemplates());
    }

    public void setGeneratedSourcesManager(GeneratedSourcesManager generatedSourcesManager) {
        GeneratedSourcesManagerJava generatedSourcesManagerJava = (GeneratedSourcesManagerJava) generatedSourcesManager;

        codegenHelper.setGeneratedSourcesManager(generatedSourcesManagerJava);
        String baseDir = generatedSourcesManagerJava.getSourcePath();
        codegenHelper.setBaseDir(baseDir);
    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String filename = "BehaviourCreator.java";
        codegenHelper.createBehaviourCreator(filename, behaviours);
    }

    @Override
    public void createBehaviourImpl(Behaviour behaviour) {
        String filename = StringUtils.capitalize(behaviour.getName()) + "Impl.java";
        codegenHelper.createBehaviourImpl(filename, behaviour);
    }

    @Override
    public void preConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "PreCondition" + behaviour.getPreCondition().getId() + "Impl.java";
        codegenHelper.preConditionBehaviourImpl(filename, behaviour);
    }

    @Override
    public void preConditionCreator(Behaviour behaviour) {
        String filename = "PreCondition" + behaviour.getId() + ".java";
        codegenHelper.preConditionCreator(filename, behaviour);
    }

    @Override
    public void runtimeConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "RunTimeCondition" + behaviour.getRuntimeCondition().getId() + "Impl.java";
        codegenHelper.runtimeConditionBehaviourImpl(filename, behaviour);
    }

    @Override
    public void runtimeConditionCreator(Behaviour behaviour) {
        String filename = "RunTimeCondition" + behaviour.getId() + ".java";
        codegenHelper.runtimeConditionCreator(filename, behaviour);
    }

    @Override
    public void postConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "PostCondition" + behaviour.getPostCondition().getId() + "Impl.java";
        codegenHelper.postConditionBehaviourImpl(filename, behaviour);
    }

    @Override
    public void postConditionCreator(Behaviour behaviour) {
        String filename = "PostCondition" + behaviour.getId() + ".java";
        codegenHelper.postConditionCreator(filename, behaviour);
    }

    public void createBehaviours(Behaviour behaviour) {
        super.createBehaviours(behaviour);
        String filename = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + ".java";
        codegenHelper.createBehaviourCondition(filename, behaviour);
        String filename2 = StringUtils.capitalize(behaviour.getName()) + ".java";
        codegenHelper.createBehaviour(filename2, behaviour);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filename = "ConditionCreator.java";
        codegenHelper.createConditionCreator(filename, plans, behaviours, conditions);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filename = "ConstraintCreator.java";
        codegenHelper.createConstraintCreator(filename, plans, behaviours, conditions);
    }

    public void constraintPreCondition(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getPreCondition().getId() + ".java";
        codegenHelper.constraintPreCondition(filename, behaviour);
    }

    public void constraintPreConditionImpl(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getPreCondition().getId() + "Impl.java";
        codegenHelper.constraintPreConditionImpl(filename, behaviour);
    }

    public void constraintRuntimeCondition(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getRuntimeCondition().getId() + ".java";
        codegenHelper.constraintRuntimeCondition(filename, behaviour);
    }

    public void constraintRuntimeConditionImpl(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getRuntimeCondition().getId() + "Impl.java";
        codegenHelper.constraintRuntimeConditionImpl(filename, behaviour);
    }

    public void constraintPostCondition(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getPostCondition().getId() + ".java";
        codegenHelper.constraintPostCondition(filename, behaviour);
    }

    public void constraintPostConditionImpl(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getPostCondition().getId() + "Impl.java";
        codegenHelper.constraintPostConditionImpl(filename, behaviour);
    }

    public void createConstraintsForBehaviour(Behaviour behaviour) {
        super.createConstraintsForBehaviour(behaviour);
        String filename = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + "Constraints.java";
        codegenHelper.createBehaviourConstraints(filename, behaviour);
    }

    public void constraintPlanPreCondition(Plan plan) {
        String filename = "Constraint" + plan.getPreCondition().getId() + ".java";
        codegenHelper.constraintPlanPreCondition(filename, plan);
    }

    public void constraintPlanPreConditionImpl(Plan plan) {
        String filename = "Constraint" + plan.getPreCondition().getId() + "Impl.java";
        codegenHelper.constraintPlanPreConditionImpl(filename, plan);
    }

    public void constraintPlanRuntimeCondition(Plan plan) {
        String filename = "Constraint" + plan.getRuntimeCondition().getId() + ".java";
        codegenHelper.constraintPlanRuntimeCondition(filename, plan);
    }

    public void constraintPlanRuntimeConditionImpl(Plan plan) {
        String filename = "Constraint" + plan.getRuntimeCondition().getId() + "Impl.java";
        codegenHelper.constraintPlanRuntimeConditionImpl(filename, plan);
    }

    public void constraintPlanTransitionPreCondition(Plan plan, Transition transition) {
        String filename = "Constraint" + transition.getPreCondition().getId() + ".java";
        codegenHelper.constraintPlanTransitionPreCondition(filename, plan, transition);
    }

    public void constraintPlanTransitionPreConditionImpl(Transition transition) {
        String filename = "Constraint" + transition.getPreCondition().getId() + "Impl.java";
        codegenHelper.constraintPlanTransitionPreConditionImpl(filename, transition);
    }

    public void createConstraintsForPlan(Plan plan) {
        super.createConstraintsForPlan(plan);
        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + "Constraints.java";
        codegenHelper.createPlanConstraints(filename, plan);
        codegenHelper.readConstraintsForPlan(filename, plan);
    }

    @Override
    public void createDomainBehaviour() {
        this.createDomainBehaviourImpl();
        String filename = "DomainBehaviour.java";
        codegenHelper.createDomainBehaviour(filename);
    }

    private void createDomainBehaviourImpl() {
        String filename = "DomainBehaviourImpl.java";
        codegenHelper.createDomainBehaviourImpl(filename);
    }

    @Override
    public void createDomainCondition() {
        this.createDomainConditionImpl();
        String filename = "DomainCondition.java";
        codegenHelper.createDomainCondition(filename);
    }

    private void createDomainConditionImpl() {
        String filename = "DomainConditionImpl.java";
        codegenHelper.createDomainConditionImpl(filename);
    }

    public void utilityFunctionPlan(Plan plan) {
        String filename = "UtilityFunction" + plan.getId() + ".java";
        codegenHelper.utilityFunctionPlan(filename, plan);
    }

    public void utilityFunctionPlanImpl(Plan plan) {
        String filename = "UtilityFunction" + plan.getId() + "Impl.java";
        codegenHelper.utilityFunctionPlanImpl(filename, plan);
    }

    public void preConditionPlan(Plan plan) {
        String filename = "PreCondition" + plan.getPreCondition().getId() + ".java";
        codegenHelper.preConditionPlan(filename, plan);
    }

    public void preConditionPlanImpl(Plan plan) {
        String filename = "PreCondition" + plan.getPreCondition().getId() + "Impl.java";
        codegenHelper.preConditionPlanImpl(filename, plan);
    }

    public void runtimeConditionPlan(Plan plan) {
        String filename = "RunTimeCondition" + plan.getRuntimeCondition().getId() + ".java";
        codegenHelper.runtimeConditionPlan(filename, plan);
    }

    public void runtimeConditionPlanImpl(Plan plan) {
        String filename = "RunTimeCondition" + plan.getRuntimeCondition().getId() + "Impl.java";
        codegenHelper.runtimeConditionPlanImpl(filename, plan);
    }

    public void transitionPreConditionPlan(State state, Transition transition) {
        String filename = "PreCondition" + transition.getPreCondition().getId() + ".java";
        codegenHelper.transitionPreConditionPlan(filename, state, transition);
    }

    public void transitionPreConditionPlanImpl(Transition transition) {
        String filename = "PreCondition" + transition.getPreCondition().getId() + "Impl.java";
        codegenHelper.transitionPreConditionPlanImpl(filename, transition);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String filename = "UtilityFunctionCreator.java";
        codegenHelper.createUtilityFunctionCreator(filename, plans);
    }
}
