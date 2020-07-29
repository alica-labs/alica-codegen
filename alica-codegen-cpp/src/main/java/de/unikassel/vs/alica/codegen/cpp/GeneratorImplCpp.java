package de.unikassel.vs.alica.codegen.cpp;

import de.unikassel.vs.alica.codegen.*;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;

/**
 * The following lines must be the following. If they are not, they must be re-inserted.
 *
 * import de.unikassel.vs.alica.codegen.cpp.templates.*;
 */
import de.unikassel.vs.alica.codegen.cpp.templates.*;

import org.apache.commons.lang3.StringUtils;

import java.util.List;


/**
 * Code generator for Java. It uses the XtendTemplates for creating the code.
 * After this the created strings are written to disk according to {@link GeneratedSourcesManagerCpp}.
 */
public class GeneratorImplCpp extends GeneratorImpl implements IGenerator {
    private final CodegenHelper codegenHelperHeader;
    private final CodegenHelper codegenHelperSource;

    public GeneratorImplCpp() {
        codegenHelperHeader = new CodegenHelper();
        codegenHelperHeader.setCreatorTemplates(new CreatorTemplatesHeader());
        codegenHelperHeader.setBehaviourTemplates(new BehaviourTemplatesHeader());
        codegenHelperHeader.setDomainTemplates(new DomainTemplatesHeader());
        codegenHelperHeader.setPlanTemplates(new PlanTemplatesHeader());
        codegenHelperHeader.setTransitionTemplates(new TransitionTemplatesHeader());

        codegenHelperSource = new CodegenHelper();
        codegenHelperSource.setCreatorTemplates(new CreatorTemplatesSource());
        codegenHelperSource.setBehaviourTemplates(new BehaviourTemplatesSource());
        codegenHelperSource.setDomainTemplates(new DomainTemplatesSource());
        codegenHelperSource.setPlanTemplates(new PlanTemplatesSource());
        codegenHelperSource.setTransitionTemplates(new TransitionTemplatesSource());
    }

    public void setGeneratedSourcesManager(GeneratedSourcesManager generatedSourcesManager) {
        GeneratedSourcesManagerCpp generatedSourcesManagerCpp = (GeneratedSourcesManagerCpp) generatedSourcesManager;

        codegenHelperHeader.setGeneratedSourcesManager(generatedSourcesManagerCpp);
        String headerPath = generatedSourcesManagerCpp.getHeaderPath();
        codegenHelperHeader.setBaseDir(headerPath);

        codegenHelperSource.setGeneratedSourcesManager(generatedSourcesManagerCpp);
        String sourcePath = generatedSourcesManagerCpp.getSourcePath();
        codegenHelperSource.setBaseDir(sourcePath);
    }

    @Override
    public void createBehaviourCreator(List<Behaviour> behaviours) {
        String filenameHeader = "BehaviourCreator.h";
        codegenHelperHeader.createBehaviourCreator(filenameHeader, behaviours);

        String filenameSource = "BehaviourCreator.cpp";
        codegenHelperSource.createBehaviourCreator(filenameSource, behaviours);
    }

    @Override
    public void createBehaviourImpl(Behaviour behaviour) {
        String filenameHeader = StringUtils.capitalize(behaviour.getName()) + "Impl.h";
        codegenHelperHeader.createBehaviourImpl(filenameHeader, behaviour);
        
        String filenameSource = StringUtils.capitalize(behaviour.getName()) + "Impl.cpp";
        codegenHelperSource.createBehaviourImpl(filenameSource, behaviour);
    }

    @Override
    public void preConditionBehaviourImpl(Behaviour behaviour) {
        String filenameHeader = "PreCondition" + behaviour.getPreCondition().getId() + "Impl.h";
        codegenHelperHeader.preConditionBehaviourImpl(filenameHeader, behaviour);
        
        String filenameSource = "PreCondition" + behaviour.getPreCondition().getId() + "Impl.cpp";
        codegenHelperSource.preConditionBehaviourImpl(filenameSource, behaviour);
    }

    @Override
    public void preConditionCreator(Behaviour behaviour) {
        String filenameHeader = "PreCondition" + behaviour.getId() + ".h";
        codegenHelperHeader.preConditionCreator(filenameHeader, behaviour);
        
        String filenameSource = "PreCondition" + behaviour.getId() + ".cpp";
        codegenHelperSource.preConditionCreator(filenameSource, behaviour);
    }

    @Override
    public void runtimeConditionBehaviourImpl(Behaviour behaviour) {
        String filenameHeader = "RunTimeCondition" + behaviour.getRuntimeCondition().getId() + "Impl.h";
        codegenHelperHeader.runtimeConditionBehaviourImpl(filenameHeader, behaviour);
        
        String filenameSource = "RunTimeCondition" + behaviour.getRuntimeCondition().getId() + "Impl.cpp";
        codegenHelperSource.runtimeConditionBehaviourImpl(filenameSource, behaviour);
    }

    @Override
    public void runtimeConditionCreator(Behaviour behaviour) {
        String filenameHeader = "RunTimeCondition" + behaviour.getId() + ".h";
        codegenHelperHeader.runtimeConditionCreator(filenameHeader, behaviour);
        
        String filenameSource = "RunTimeCondition" + behaviour.getId() + ".cpp";
        codegenHelperSource.runtimeConditionCreator(filenameSource, behaviour);
    }

    @Override
    public void postConditionBehaviourImpl(Behaviour behaviour) {
        String filenameHeader = "PostCondition" + behaviour.getPostCondition().getId() + "Impl.h";
        codegenHelperHeader.postConditionBehaviourImpl(filenameHeader, behaviour);
        
        String filenameSource = "PostCondition" + behaviour.getPostCondition().getId() + "Impl.cpp";
        codegenHelperSource.postConditionBehaviourImpl(filenameSource, behaviour);
    }

    @Override
    public void postConditionCreator(Behaviour behaviour) {
        String filenameHeader = "PostCondition" + behaviour.getId() + ".h";
        codegenHelperHeader.postConditionCreator(filenameHeader, behaviour);
        
        String filenameSource = "PostCondition" + behaviour.getId() + ".cpp";
        codegenHelperSource.postConditionCreator(filenameSource, behaviour);
    }

    public void createBehaviours(Behaviour behaviour) {
        super.createBehaviours(behaviour);

        String filenameHeader = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + ".h";
        codegenHelperHeader.createBehaviourCondition(filenameHeader, behaviour);
        String filenameHeader2 = StringUtils.capitalize(behaviour.getName()) + ".h";
        codegenHelperHeader.createBehaviour(filenameHeader2, behaviour);
        
        String filenameSource = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + ".cpp";
        codegenHelperSource.createBehaviourCondition(filenameSource, behaviour);
        String filenameSource2 = StringUtils.capitalize(behaviour.getName()) + ".cpp";
        codegenHelperSource.createBehaviour(filenameSource2, behaviour);
    }

    @Override
    public void createConditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filenameHeader = "ConditionCreator.h";
        codegenHelperHeader.createConditionCreator(filenameHeader, plans, behaviours, conditions);
        
        String filenameSource = "ConditionCreator.cpp";
        codegenHelperSource.createConditionCreator(filenameSource, plans, behaviours, conditions);
    }

    @Override
    public void createConstraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) {
        String filenameHeader = "ConstraintCreator.h";
        codegenHelperHeader.createConstraintCreator(filenameHeader, plans, behaviours, conditions);

        String filenameSource = "ConstraintCreator.cpp";
        codegenHelperSource.createConstraintCreator(filenameSource, plans, behaviours, conditions);
    }

    public void constraintPreCondition(Behaviour behaviour) {
        String filenameHeader = "Constraint" + behaviour.getPreCondition().getId() + ".h";
        codegenHelperHeader.constraintPreCondition(filenameHeader, behaviour);

        String filenameSource = "Constraint" + behaviour.getPreCondition().getId() + ".cpp";
        codegenHelperSource.constraintPreCondition(filenameSource, behaviour);
    }

    public void constraintPreConditionImpl(Behaviour behaviour) {
        String filenameHeader = "Constraint" + behaviour.getPreCondition().getId() + "Impl.h";
        codegenHelperHeader.constraintPreConditionImpl(filenameHeader, behaviour);

        String filenameSource = "Constraint" + behaviour.getPreCondition().getId() + "Impl.cpp";
        codegenHelperSource.constraintPreConditionImpl(filenameSource, behaviour);
    }

    public void constraintRuntimeCondition(Behaviour behaviour) {
        String filenameHeader = "Constraint" + behaviour.getRuntimeCondition().getId() + ".h";
        codegenHelperHeader.constraintRuntimeCondition(filenameHeader, behaviour);

        String filenameSource = "Constraint" + behaviour.getRuntimeCondition().getId() + ".cpp";
        codegenHelperSource.constraintRuntimeCondition(filenameSource, behaviour);
    }

    public void constraintRuntimeConditionImpl(Behaviour behaviour) {
        String filenameHeader = "Constraint" + behaviour.getRuntimeCondition().getId() + "Impl.h";
        codegenHelperHeader.constraintRuntimeConditionImpl(filenameHeader, behaviour);

        String filenameSource = "Constraint" + behaviour.getRuntimeCondition().getId() + "Impl.cpp";
        codegenHelperSource.constraintRuntimeConditionImpl(filenameSource, behaviour);
    }

    public void constraintPostCondition(Behaviour behaviour) {
        String filenameHeader = "Constraint" + behaviour.getPostCondition().getId() + ".h";
        codegenHelperHeader.constraintPostCondition(filenameHeader, behaviour);
        
        String filenameSource = "Constraint" + behaviour.getPostCondition().getId() + ".cpp";
        codegenHelperSource.constraintPostCondition(filenameSource, behaviour);
    }

    public void constraintPostConditionImpl(Behaviour behaviour) {
        String filenameHeader = "Constraint" + behaviour.getPostCondition().getId() + "Impl.h";
        codegenHelperHeader.constraintPostConditionImpl(filenameHeader, behaviour);
        
        String filenameSource = "Constraint" + behaviour.getPostCondition().getId() + "Impl.cpp";
        codegenHelperSource.constraintPostConditionImpl(filenameSource, behaviour);
    }

    public void createConstraintsForBehaviour(Behaviour behaviour) {
        super.createConstraintsForBehaviour(behaviour);
        
        String filenameHeader = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + "Constraints.h";
        codegenHelperHeader.createBehaviourConstraints(filenameHeader, behaviour);

        String filenameSource = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + "Constraints.cpp";
        codegenHelperSource.createBehaviourConstraints(filenameSource, behaviour);
    }

    public void constraintPlanPreCondition(Plan plan) {
        String filenameHeader = "Constraint" + plan.getPreCondition().getId() + ".h";
        codegenHelperHeader.constraintPlanPreCondition(filenameHeader, plan);

        String filenameSource = "Constraint" + plan.getPreCondition().getId() + ".cpp";
        codegenHelperSource.constraintPlanPreCondition(filenameSource, plan);
    }

    public void constraintPlanPreConditionImpl(Plan plan) {
        String filenameHeader = "Constraint" + plan.getPreCondition().getId() + "Impl.h";
        codegenHelperHeader.constraintPlanPreConditionImpl(filenameHeader, plan);

        String filenameSource = "Constraint" + plan.getPreCondition().getId() + "Impl.cpp";
        codegenHelperSource.constraintPlanPreConditionImpl(filenameSource, plan);
    }

    public void constraintPlanRuntimeCondition(Plan plan) {
        String filenameHeader = "Constraint" + plan.getRuntimeCondition().getId() + ".h";
        codegenHelperHeader.constraintPlanRuntimeCondition(filenameHeader, plan);

        String filenameSource = "Constraint" + plan.getRuntimeCondition().getId() + ".cpp";
        codegenHelperSource.constraintPlanRuntimeCondition(filenameSource, plan);
    }

    public void constraintPlanRuntimeConditionImpl(Plan plan) {
        String filenameHeader = "Constraint" + plan.getRuntimeCondition().getId() + "Impl.h";
        codegenHelperHeader.constraintPlanRuntimeConditionImpl(filenameHeader, plan);

        String filenameSource = "Constraint" + plan.getRuntimeCondition().getId() + "Impl.cpp";
        codegenHelperSource.constraintPlanRuntimeConditionImpl(filenameSource, plan);
    }

    public void constraintPlanTransitionPreCondition(Plan plan, Transition transition) {
        String filenameHeader = "Constraint" + transition.getPreCondition().getId() + ".h";
        codegenHelperHeader.constraintPlanTransitionPreCondition(filenameHeader, plan, transition);

        String filenameSource = "Constraint" + transition.getPreCondition().getId() + ".cpp";
        codegenHelperSource.constraintPlanTransitionPreCondition(filenameSource, plan, transition);
    }

    public void constraintPlanTransitionPreConditionImpl(Transition transition) {
        String filenameHeader = "Constraint" + transition.getPreCondition().getId() + "Impl.h";
        codegenHelperHeader.constraintPlanTransitionPreConditionImpl(filenameHeader, transition);

        String filenameSource = "Constraint" + transition.getPreCondition().getId() + "Impl.cpp";
        codegenHelperSource.constraintPlanTransitionPreConditionImpl(filenameSource, transition);
    }

    public void createConstraintsForPlan(Plan plan) {
        super.createConstraintsForPlan(plan);
        
        String filenameHeader = StringUtils.capitalize(plan.getName()) + plan.getId() + "Constraints.h";
        codegenHelperHeader.createPlanConstraints(filenameHeader, plan);
        codegenHelperHeader.readConstraintsForPlan(filenameHeader, plan);

        String filenameSource = StringUtils.capitalize(plan.getName()) + plan.getId() + "Constraints.cpp";
        codegenHelperSource.createPlanConstraints(filenameSource, plan);
        codegenHelperSource.readConstraintsForPlan(filenameSource, plan);
    }

    @Override
    public void createDomainBehaviour() {
        this.createDomainBehaviourImpl();
        
        String filenameHeader = "DomainBehaviour.h";
        codegenHelperHeader.createDomainBehaviour(filenameHeader);

        String filenameSource = "DomainBehaviour.cpp";
        codegenHelperSource.createDomainBehaviour(filenameSource);
    }

    private void createDomainBehaviourImpl() {
        String filenameHeader = "DomainBehaviourImpl.h";
        codegenHelperHeader.createDomainBehaviourImpl(filenameHeader);

        String filenameSource = "DomainBehaviourImpl.cpp";
        codegenHelperSource.createDomainBehaviourImpl(filenameSource);
    }

    @Override
    public void createDomainCondition() {
        this.createDomainConditionImpl();
        
        String filenameHeader = "DomainCondition.h";
        codegenHelperHeader.createDomainCondition(filenameHeader);

        String filenameSource = "DomainCondition.cpp";
        codegenHelperSource.createDomainCondition(filenameSource);
    }

    private void createDomainConditionImpl() {
        String filenameHeader = "DomainConditionImpl.h";
        codegenHelperHeader.createDomainConditionImpl(filenameHeader);

        String filenameSource = "DomainConditionImpl.cpp";
        codegenHelperSource.createDomainConditionImpl(filenameSource);
    }

    public void utilityFunctionPlan(Plan plan) {
        String filenameHeader = "UtilityFunction" + plan.getId() + ".h";
        codegenHelperHeader.utilityFunctionPlan(filenameHeader, plan);

        String filenameSource = "UtilityFunction" + plan.getId() + ".cpp";
        codegenHelperSource.utilityFunctionPlan(filenameSource, plan);
    }

    public void utilityFunctionPlanImpl(Plan plan) {
        String filenameHeader = "UtilityFunction" + plan.getId() + "Impl.h";
        codegenHelperHeader.utilityFunctionPlanImpl(filenameHeader, plan);

        String filenameSource = "UtilityFunction" + plan.getId() + "Impl.cpp";
        codegenHelperSource.utilityFunctionPlanImpl(filenameSource, plan);
    }

    public void preConditionPlan(Plan plan) {
        String filenameHeader = "PreCondition" + plan.getPreCondition().getId() + ".h";
        codegenHelperHeader.preConditionPlan(filenameHeader, plan);

        String filenameSource = "PreCondition" + plan.getPreCondition().getId() + ".cpp";
        codegenHelperSource.preConditionPlan(filenameSource, plan);
    }

    public void preConditionPlanImpl(Plan plan) {
        String filenameHeader = "PreCondition" + plan.getPreCondition().getId() + "Impl.h";
        codegenHelperHeader.preConditionPlanImpl(filenameHeader, plan);

        String filenameSource = "PreCondition" + plan.getPreCondition().getId() + "Impl.cpp";
        codegenHelperSource.preConditionPlanImpl(filenameSource, plan);
    }

    public void runtimeConditionPlan(Plan plan) {
        String filenameHeader = "RunTimeCondition" + plan.getRuntimeCondition().getId() + ".h";
        codegenHelperHeader.runtimeConditionPlan(filenameHeader, plan);

        String filenameSource = "RunTimeCondition" + plan.getRuntimeCondition().getId() + ".cpp";
        codegenHelperSource.runtimeConditionPlan(filenameSource, plan);
    }

    public void runtimeConditionPlanImpl(Plan plan) {
        String filenameHeader = "RunTimeCondition" + plan.getRuntimeCondition().getId() + "Impl.h";
        codegenHelperHeader.runtimeConditionPlanImpl(filenameHeader, plan);

        String filenameSource = "RunTimeCondition" + plan.getRuntimeCondition().getId() + "Impl.cpp";
        codegenHelperSource.runtimeConditionPlanImpl(filenameSource, plan);
    }

    public void transitionPreConditionPlan(State state, Transition transition) {
        String filenameHeader = "PreCondition" + transition.getPreCondition().getId() + ".h";
        codegenHelperHeader.transitionPreConditionPlan(filenameHeader, state, transition);

        String filenameSource = "PreCondition" + transition.getPreCondition().getId() + ".cpp";
        codegenHelperSource.transitionPreConditionPlan(filenameSource, state, transition);
    }

    public void transitionPreConditionPlanImpl(Transition transition) {
        String filenameHeader = "PreCondition" + transition.getPreCondition().getId() + "Impl.h";
        codegenHelperHeader.transitionPreConditionPlanImpl(filenameHeader, transition);

        String filenameSource = "PreCondition" + transition.getPreCondition().getId() + "Impl.cpp";
        codegenHelperSource.transitionPreConditionPlanImpl(filenameSource, transition);
    }

    @Override
    public void createUtilityFunctionCreator(List<Plan> plans) {
        String filenameHeader = "UtilityFunctionCreator.h";
        codegenHelperHeader.createUtilityFunctionCreator(filenameHeader, plans);

        String filenameSource = "UtilityFunctionCreator.cpp";
        codegenHelperSource.createUtilityFunctionCreator(filenameSource, plans);
    }
}
