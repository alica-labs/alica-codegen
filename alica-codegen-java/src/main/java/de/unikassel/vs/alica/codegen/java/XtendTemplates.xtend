package de.unikassel.vs.alica.codegen.java

import de.unikassel.vs.alica.codegen.IConstraintCodeGenerator
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition
import de.unikassel.vs.alica.planDesigner.alicamodel.RuntimeCondition
import java.util.List
import java.util.Map
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition
import de.unikassel.vs.alica.planDesigner.alicamodel.EntryPoint
import de.unikassel.vs.alica.planDesigner.alicamodel.State
import de.unikassel.vs.alica.planDesigner.alicamodel.Variable
import org.apache.commons.lang3.StringUtils;


class XtendTemplates {

    def String behaviourCreator(List<Behaviour> behaviours)'''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicBehaviour;
«FOR beh : behaviours»
    «IF (!beh.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«beh.relativeDirectory».«StringUtils.capitalize(beh.name)»;
    «ENDIF»
«ENDFOR»

public class BehaviourCreator {
    public BasicBehaviour createBehaviour(long behaviourId) throws Exception {
        switch (String.valueOf(behaviourId)) {
            «FOR beh : behaviours»
                case "«beh.id»":
                    return new «StringUtils.capitalize(beh.name)»();
            «ENDFOR»
            default:
                System.err.println("BehaviourCreator: Unknown behaviour requested: " + behaviourId);
                throw new Exception();
        }
    }
}
'''

    def String behaviour(Behaviour behaviour) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«behaviour.relativeDirectory»;
«ENDIF»

import de.unikassel.vs.alica.codegen.out.impl.«StringUtils.capitalize(behaviour.name)»Impl;

public class «StringUtils.capitalize(behaviour.name)» extends DomainBehaviour {
    private «StringUtils.capitalize(behaviour.name)»Impl impl;

    public «StringUtils.capitalize(behaviour.name)»() {
        super("«behaviour.name»");
        impl = new «StringUtils.capitalize(behaviour.name)»Impl();
    }

    public void run(Object msg) {
        impl.run(msg);
    }

    public void initialiseParameters() {
        impl.initialiseParameters();
    }
}
'''

    def String behaviourImpl(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out.impl;

public class «StringUtils.capitalize(behaviour.name)»Impl {
    public «StringUtils.capitalize(behaviour.name)»Impl() {

    }

    public void run(Object msg) {

    }

    public void initialiseParameters() {

    }
}
'''

    def String utilityFunctionCreator(List<Plan> plans)'''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicUtilityFunction;
«FOR p: plans»
    «IF (!p.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«p.relativeDirectory».«StringUtils.capitalize(p.name)»«p.id»;
    «ENDIF»
«ENDFOR»

public class UtilityFunctionCreator {
    public BasicUtilityFunction createUtility(long utilityfunctionConfId) throws Exception {
        switch(String.valueOf(utilityfunctionConfId)) {
            «FOR p: plans»
                case "«p.id»":
                    return new UtilityFunction«p.id»();
            «ENDFOR»
            default:
                System.err.println("UtilityFunctionCreator: Unknown utility requested: " + utilityfunctionConfId);
                throw new Exception();
        }
    }
}
'''

    def String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicCondition;

public class ConditionCreator {
    public BasicCondition createConditions(long conditionConfId) throws Exception {
        switch (String.valueOf(conditionConfId)) {
            «FOR con: conditions»
                case "«con.id»":
                    «IF (con instanceof PreCondition)»
                        return new PreCondition«con.id»();
                    «ENDIF»
                    «IF (con instanceof PostCondition)»
                        return new PostCondition«con.id»();
                    «ENDIF»
                    «IF (con instanceof RuntimeCondition)»
                        return new RunTimeCondition«con.id»();
                    «ENDIF»
            «ENDFOR»
            default:
                System.err.println("ConditionCreator: Unknown condition id requested: " + conditionConfId);
                throw new Exception();
        }
    }
}
'''

    def String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicCondition;

public class ConstraintCreator {
    public BasicCondition createConstraint(long constraintConfId) throws Exception {
        switch (String.valueOf(constraintConfId)) {
            «FOR c: conditions»
                «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                    case "«c.id»":
                        return new Constraint«c.id»();
                «ENDIF»
            «ENDFOR»
            default:
                System.err.println("ConstraintCreator: Unknown constraint requested: " + constraintConfId);
                throw new Exception();
        }
    }
}
'''

    def String behaviourCondition(Behaviour behaviour, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«behaviour.relativeDirectory»;
«ENDIF»

public class «StringUtils.capitalize(behaviour.name)»«behaviour.id» {
    public «StringUtils.capitalize(behaviour.name)»«behaviour.id»() {
        // TODO: removed constraintCodeGenerator.expressionsBehaviourCheckingMethods(behaviour) that generates c++ code
    }
}
'''

    def String preConditionBehaviour(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

public class PreCondition«behaviour.preCondition.id» extends DomainCondition {

}
'''

    def String runtimeConditionBehaviour(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

public class RunTimeCondition«behaviour.runtimeCondition.id» extends DomainCondition {

}
'''

    def String postConditionBehaviour(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

public class PostCondition«behaviour.postCondition.id» extends DomainCondition {

}
'''

    def String constraints(Behaviour behaviour, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out.constraints;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«behaviour.relativeDirectory».constraints;
«ENDIF»

public class «StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints {
    public «StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints() {
        // TODO: removed constraintCodeGenerator.constraintBehaviourCheckingMethods(behaviour) that generates c++ code
    }
}
'''

    def String constraintPreCondition(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

public class Constraint«behaviour.preCondition.id» extends BasicConstraint {
    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintRuntimeCondition(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

public class Constraint«behaviour.runtimeCondition.id» extends BasicConstraint {
    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintPostCondition(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

public class Constraint«behaviour.postCondition.id» extends BasicConstraint {
    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraints(Plan plan, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (plan.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out.constraints;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«plan.relativeDirectory».constraints;
«ENDIF»

public class «StringUtils.capitalize(plan.name)»«plan.id»Constraints {
    public «StringUtils.capitalize(plan.name)»«plan.id»Constraints() {
        // TODO: removed constraintCodeGenerator.constraintPlanCheckingMethods(plan) that generates c++ code
        // TODO: removed constraintCodeGenerator.constraintStateCheckingMethods(state) that generates c++ code
    }
}
'''

    def String constraintPlanPreCondition(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

public class Constraint«plan.preCondition.id» extends BasicConstraint {
    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintPlanRuntimeCondition(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

public class Constraint«plan.runtimeCondition.id» extends BasicConstraint {
    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintPlanTransitionPreCondition(Transition transition) '''
package de.unikassel.vs.alica.codegen.out;

public class Constraint«transition.preCondition.id» extends BasicConstraint {
    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String domainBehaviour() '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicBehaviour;
import de.unikassel.vs.alica.codegen.out.impl.DomainBehaviourImpl;

public class DomainBehaviour extends BasicBehaviour {
    private DomainBehaviourImpl impl;

    public DomainBehaviour(String name) {
        super(name);
        impl = new DomainBehaviourImpl();
    }
}
'''

    def String domainBehaviourImpl() '''
package de.unikassel.vs.alica.codegen.out.impl;

public class DomainBehaviourImpl {
    public DomainBehaviourImpl() {

    }
}
'''

    def String domainCondition() '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicCondition;
import de.unikassel.vs.alica.codegen.out.impl.DomainConditionImpl;

public class DomainCondition extends BasicCondition {
    private DomainConditionImpl impl;

    public DomainCondition() {
        super();
        impl = new DomainConditionImpl();
    }
}
'''

    def String domainConditionImpl() '''
package de.unikassel.vs.alica.codegen.out.impl;

public class DomainConditionImpl {
    public DomainConditionImpl() {

    }
}
'''

    def String plan(Plan plan, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (plan.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«plan.relativeDirectory»;
«ENDIF»
import de.unikassel.vs.alica.engine.BasicPlan;
import de.unikassel.vs.alica.engine.BasicUtilityFunction;
import de.unikassel.vs.alica.codegen.out.impl.«StringUtils.capitalize(plan.name)»«plan.id»Impl;

public class «StringUtils.capitalize(plan.name)»«plan.id» extends BasicPlan {
    private «StringUtils.capitalize(plan.name)»«plan.id»Impl impl;

    // TODO: removed constraintCodeGenerator.expressionsPlanCheckingMethods(plan) that generates c++ code

    public «StringUtils.capitalize(plan.name)»«plan.id»() {
        impl = new «StringUtils.capitalize(plan.name)»«plan.id»Impl();
    }

    public BasicUtilityFunction getUtilityFunction(BasicPlan plan) {
        return impl.getUtilityFunction(plan);
    }

    // TODO: removed constraintCodeGenerator.expressionsStateCheckingMethods(state) that generates c++ code
}
'''

    def String utilityFunctionPlan(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicUtilityFunction;
import de.unikassel.vs.alica.engine.BasicPlan;
import de.unikassel.vs.alica.engine.UtilityFunction;
import de.unikassel.vs.alica.codegen.out.impl.UtilityFunction«plan.id»Impl;

public class UtilityFunction«plan.id» extends BasicUtilityFunction {
    private UtilityFunction«plan.id»Impl impl;

    public UtilityFunction«plan.id»() {
        impl = new UtilityFunction«plan.id»Impl();
    }

    public UtilityFunction getUtilityFunction(BasicPlan plan) {
        return impl.getUtilityFunction(plan);
    }
}
'''

    def String utilityFunctionPlanImpl(Plan plan) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.BasicPlan;
import de.unikassel.vs.alica.engine.UtilityFunction;
import de.unikassel.vs.alica.engine.DefaultUtilityFunction;

public class UtilityFunction«plan.id»Impl {
    public UtilityFunction«plan.id»Impl() {

    }

    public UtilityFunction getUtilityFunction(BasicPlan plan) {
        UtilityFunction defaultFunction = new DefaultUtilityFunction(plan);
        return defaultFunction;
    }
}
'''

    def String preConditionPlan(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

public class PreCondition«plan.preCondition.id» extends DomainCondition {

}
'''

    def String runtimeConditionPlan(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

public class RunTimeCondition«plan.runtimeCondition.id» extends DomainCondition {

}
'''

    def String transitionPreConditionPlan(Transition transition) '''
package de.unikassel.vs.alica.codegen.out;

public class PreCondition«transition.preCondition.id» extends DomainCondition {

}
'''

    def String planImpl(Plan plan) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.BasicPlan;
import de.unikassel.vs.alica.engine.BasicUtilityFunction;
import de.unikassel.vs.alica.engine.DefaultUtilityFunction;

public class «StringUtils.capitalize(plan.name)»«plan.id»Impl {
    public BasicUtilityFunction getUtilityFunction(BasicPlan plan) {
        return new DefaultUtilityFunction(plan);
    }
}
'''
}
