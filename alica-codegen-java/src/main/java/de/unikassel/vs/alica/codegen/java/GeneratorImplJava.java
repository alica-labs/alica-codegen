package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerJava;
import de.unikassel.vs.alica.codegen.GeneratorImpl;
import de.unikassel.vs.alica.codegen.IGenerator;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
/**
 * The following lines must be the following. If they are not, they must be re-inserted.
 *
 * import de.unikassel.vs.alica.codegen.java.CreatorTemplates;
 * import de.unikassel.vs.alica.codegen.java.BehaviourTemplates;
 * import de.unikassel.vs.alica.codegen.java.DomainTemplates;
 * import de.unikassel.vs.alica.codegen.java.PlanTemplates;
 * import de.unikassel.vs.alica.codegen.java.TransitionTemplates;
 */
import de.unikassel.vs.alica.codegen.java.CreatorTemplates;
import de.unikassel.vs.alica.codegen.java.BehaviourTemplates;
import de.unikassel.vs.alica.codegen.java.DomainTemplates;
import de.unikassel.vs.alica.codegen.java.PlanTemplates;
import de.unikassel.vs.alica.codegen.java.TransitionTemplates;
import org.apache.commons.lang3.StringUtils;

import java.util.List;
import java.util.Map;


/**
 * Code generator for Java. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerJava}.
 */
public class GeneratorImplJava extends GeneratorImpl implements IGenerator<GeneratedSourcesManagerJava> {

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
        super.setBaseDir(baseDir);
    }

    @Deprecated
    @Override
    public void setProtectedRegions(Map<String, String> protectedRegions) {

    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String filename = "BehaviourCreator.java";
        this.createBehaviourCreator(filename, behaviours);
    }

    @Override
    public void createBehaviourImpl(Behaviour behaviour) {
        String filename = StringUtils.capitalize(behaviour.getName()) + "Impl.java";
        this.createBehaviourImpl(filename, behaviour);
    }

    @Override
    public void preConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "PreCondition" + behaviour.getPreCondition().getId() + "Impl.java";
        this.preConditionBehaviourImpl(filename, behaviour);
    }

    @Override
    public void preConditionCreator(Behaviour behaviour) {
        String filename = "PreCondition" + behaviour.getId() + ".java";
        this.preConditionCreator(filename, behaviour);
    }

    @Override
    public void runtimeConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "RunTimeCondition" + behaviour.getRuntimeCondition().getId() + "Impl.java";
        this.runtimeConditionBehaviourImpl(filename, behaviour);
    }

    @Override
    public void runtimeConditionCreator(Behaviour behaviour) {
        String filename = "RunTimeCondition" + behaviour.getId() + ".java";
        this.runtimeConditionCreator(filename, behaviour);
    }

    @Override
    public void postConditionBehaviourImpl(Behaviour behaviour) {
        String filename = "PostCondition" + behaviour.getPostCondition().getId() + "Impl.java";
        this.postConditionBehaviourImpl(filename, behaviour);
    }

    @Override
    public void postConditionCreator(Behaviour behaviour) {
        String filename = "PostCondition" + behaviour.getId() + ".java";
        this.postConditionCreator(filename, behaviour);
    }

    public void createBehaviours(Behaviour behaviour) {
        super.createBehaviours(behaviour);
        String filename = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + ".java";
        this.createBehaviourCondition(filename, behaviour);
        String filename2 = StringUtils.capitalize(behaviour.getName()) + ".java";
        this.createBehaviour(filename2, behaviour);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filename = "ConditionCreator.java";
        this.createConditionCreator(filename, plans, behaviours, conditions);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filename = "ConstraintCreator.java";
        this.createConstraintCreator(filename, plans, behaviours, conditions);
    }

    public void constraintPreCondition(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getPreCondition().getId() + ".java";
        this.constraintPreCondition(filename, behaviour);
    }

    public void constraintPreConditionImpl(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getPreCondition().getId() + "Impl.java";
        this.constraintPreConditionImpl(filename, behaviour);
    }

    public void constraintRuntimeCondition(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getRuntimeCondition().getId() + ".java";
        this.constraintRuntimeCondition(filename, behaviour);
    }

    public void constraintRuntimeConditionImpl(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getRuntimeCondition().getId() + "Impl.java";
        this.constraintRuntimeConditionImpl(filename, behaviour);
    }

    public void constraintPostCondition(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getPostCondition().getId() + ".java";
        this.constraintPostCondition(filename, behaviour);
    }

    public void constraintPostConditionImpl(Behaviour behaviour) {
        String filename = "Constraint" + behaviour.getPostCondition().getId() + "Impl.java";
        this.constraintPostConditionImpl(filename, behaviour);
    }

    public void createConstraintsForBehaviour(Behaviour behaviour) {
        super.createConstraintsForBehaviour(behaviour);
        String filename = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + "Constraints.java";
        this.createBehaviourConstraints(filename, behaviour);
    }

    public void constraintPlanPreCondition(Plan plan) {
        String filename = "Constraint" + plan.getPreCondition().getId() + ".java";
        this.constraintPlanPreCondition(filename, plan);
    }

    public void constraintPlanPreConditionImpl(Plan plan) {
        String filename = "Constraint" + plan.getPreCondition().getId() + "Impl.java";
        this.constraintPlanPreConditionImpl(filename, plan);
    }

    public void constraintPlanRuntimeCondition(Plan plan) {
        String filename = "Constraint" + plan.getRuntimeCondition().getId() + ".java";
        this.constraintPlanRuntimeCondition(filename, plan);
    }

    public void constraintPlanRuntimeConditionImpl(Plan plan) {
        String filename = "Constraint" + plan.getRuntimeCondition().getId() + "Impl.java";
        this.constraintPlanRuntimeConditionImpl(filename, plan);
    }

    public void constraintPlanTransitionPreCondition(Plan plan, Transition transition) {
        String filename = "Constraint" + transition.getPreCondition().getId() + ".java";
        this.constraintPlanTransitionPreCondition(filename, plan, transition);
    }

    public void constraintPlanTransitionPreConditionImpl(Transition transition) {
        String filename = "Constraint" + transition.getPreCondition().getId() + "Impl.java";
        this.constraintPlanTransitionPreConditionImpl(filename, transition);
    }

    public void createConstraintsForPlan(Plan plan) {
        super.createConstraintsForPlan(plan);
        String filename = StringUtils.capitalize(plan.getName()) + plan.getId() + "Constraints.java";
        this.createPlanConstraints(filename, plan);
        this.readConstraintsForPlan(filename, plan);
    }

    @Override
    public void createDomainBehaviour() {
        this.createDomainBehaviourImpl();
        String filename = "DomainBehaviour.java";
        this.createDomainBehaviour(filename);
    }

    private void createDomainBehaviourImpl() {
        String filename = "DomainBehaviourImpl.java";
        this.createDomainBehaviourImpl(filename);
    }

    @Override
    public void createDomainCondition() {
        this.createDomainConditionImpl();
        String filename = "DomainCondition.java";
        this.createDomainCondition(filename);
    }

    private void createDomainConditionImpl() {
        String filename = "DomainConditionImpl.java";
        this.createDomainConditionImpl(filename);
    }

    public void utilityFunctionPlan(Plan plan) {
        String filename = "UtilityFunction" + plan.getId() + ".java";
        this.utilityFunctionPlan(filename, plan);
    }

    public void utilityFunctionPlanImpl(Plan plan) {
        String filename = "UtilityFunction" + plan.getId() + "Impl.java";
        this.utilityFunctionPlanImpl(filename, plan);
    }

    public void preConditionPlan(Plan plan) {
        this.preConditionPlanImpl(plan);
        String filename = "PreCondition" + plan.getPreCondition().getId() + ".java";
        this.preConditionPlan(filename, plan);
    }

    private void preConditionPlanImpl(Plan plan) {
        String filename = "PreCondition" + plan.getPreCondition().getId() + "Impl.java";
        this.preConditionPlanImpl(filename, plan);
    }

    public void runtimeConditionPlan(Plan plan) {
        String filename = "RunTimeCondition" + plan.getRuntimeCondition().getId() + ".java";
        this.runtimeConditionPlan(filename, plan);
    }

    public void runtimeConditionPlanImpl(Plan plan) {
        String filename = "RunTimeCondition" + plan.getRuntimeCondition().getId() + "Impl.java";
        this.runtimeConditionPlanImpl(filename, plan);
    }

    public void transitionPreConditionPlan(State state, Transition transition) {
        String filename = "PreCondition" + transition.getPreCondition().getId() + ".java";
        this.transitionPreConditionPlan(filename, state, transition);
    }

    public void transitionPreConditionPlanImpl(Transition transition) {
        String filename = "PreCondition" + transition.getPreCondition().getId() + "Impl.java";
        this.transitionPreConditionPlanImpl(filename, transition);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String filename = "UtilityFunctionCreator.java";
        this.createUtilityFunctionCreator(filename, plans);
    }
}
