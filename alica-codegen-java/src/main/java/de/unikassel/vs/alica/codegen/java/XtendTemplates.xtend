package de.unikassel.vs.alica.codegen.cpp

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

class XtendTemplates {

    def String behaviourCreator(List<Behaviour> behaviours)'''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.codegen.out.BehaviourCreator;
import de.unikassel.vs.alica.codegen.out.engine.BasicBehaviour;
«FOR beh : behaviours»
    «IF (beh.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«beh.name»;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«beh.relativeDirectory».«beh.name»;
    «ENDIF»
«ENDFOR»

public class BehaviourCreator {
    public Object createBehaviour(long behaviourId) {
        switch (behaviourId) {
            «FOR beh : behaviours»
                case «beh.id»:
                    return «beh.name»();
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

// import de.unikassel.vs.alica.codegen.out.«behaviour.name»Impl;

public class «behaviour.name» {
    // private «behaviour.name»Impl «behaviour.name»Impl = new «behaviour.name»Impl();

    // public Object run() {
    //     this.«behaviour.name»Impl.run();
    // }

    // public Object initialiseParameters() {
    //     this.«behaviour.name»Impl.initialiseParameters();
    // }
}
'''

    def String utilityFunctionCreator(List<Plan> plans)'''
package de.unikassel.vs.alica.codegen.out;

«FOR p: plans»
    «IF (p.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«p.name»«p.id»;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«p.relativeDirectory».«p.name»«p.id»;
    «ENDIF»
«ENDFOR»

public class UtilityFunctionCreator {
    public Object createUtility(long utilityfunctionConfId) {
        switch(utilityfunctionConfId) {
            «FOR p: plans»
                case «p.id»:
                    return UtilityFunction«p.id»();
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

«FOR p: plans»
    «IF (p.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«p.name»«p.id»;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«p.relativeDirectory».«p.name»«p.id»;
    «ENDIF»
«ENDFOR»
«FOR b: behaviours»
    «IF (b.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«b.name»«b.id»;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«b.relativeDirectory».«b.name»«b.id»;
    «ENDIF»
«ENDFOR»

public class ConditionCreator {
    public Object createConditions(long conditionConfId) {
        switch (conditionConfId) {
            «FOR con: conditions»
                case «con.id»:
                    «IF (con instanceof PreCondition)»
                        return PreCondition«con.id»();
                    «ENDIF»
                    «IF (con instanceof PostCondition)»
                        return PostCondition«con.id»();
                    «ENDIF»
                    «IF (con instanceof RuntimeCondition)»
                        return RunTimeCondition«con.id»();
                    «ENDIF»
                    break;
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

«FOR plan: plans»
    «IF (plan.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.constraints.«plan.name»«plan.id»Constraints;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«plan.relativeDirectory».constraints.«plan.name»«plan.id»Constraints;
    «ENDIF»
«ENDFOR»
«FOR behaviour: behaviours»
    «IF (behaviour.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.constraints.«behaviour.name»«behaviour.id»Constraints;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«behaviour.relativeDirectory».constraints.«behaviour.name»«behaviour.id»Constraints;
    «ENDIF»
«ENDFOR»

public class ConditionCreator {
    public Object createConstraint(long constraintConfId) {
        switch(constraintConfId) {
            «FOR c: conditions»
                «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                    case «c.id»:
                        return Constraint«c.id»();
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

public class «behaviour.name»«behaviour.id» {
    public «behaviour.name»«behaviour.id»() {
        «constraintCodeGenerator.expressionsBehaviourCheckingMethods(behaviour)»
    }
}
'''

    def String constraints(Behaviour behaviour, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out.constraints;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«behaviour.relativeDirectory».constraints;
«ENDIF»

public class «behaviour.name»«behaviour.id»Constraints {
    public «behaviour.name»«behaviour.id»Constraints() {
        «constraintCodeGenerator.constraintBehaviourCheckingMethods(behaviour)»
    }
}
'''

    def String constraints(Plan plan, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (plan.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out.constraints;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«plan.relativeDirectory».constraints;
«ENDIF»

public class «plan.name»«plan.id»Constraints {
    public «plan.name»«plan.id»Constraints() {
        //Plan:«plan.name»
        /*
        * Tasks: «var List<EntryPoint> entryPoints = plan.entryPoints» «FOR  planEntryPoint : entryPoints»
        * - EP:«planEntryPoint.id» : «planEntryPoint.task.name» («planEntryPoint.task.id»)«ENDFOR»
        *
        * States:«var List<State> states = plan.states» «FOR state : states»
        * - «state.name» («state.id»)«ENDFOR»
        *
        * Vars:«var List<Variable> variables = plan.variables» «FOR variable : variables»
        * - «variable.name» («variable.id») «ENDFOR»
        */
        «constraintCodeGenerator.constraintPlanCheckingMethods(plan)»
        «FOR state: states»
            «constraintCodeGenerator.constraintStateCheckingMethods(state)»
        «ENDFOR»
    }
}
'''

    def String domainBehaviour() '''
package de.unikassel.vs.alica.codegen.out.DomainBehaviour;

public class DomainBehaviour {
}
'''

    def String domainCondition() '''
package de.unikassel.vs.alica.codegen.out.DomainCondition;

public class DomainCondition {
}
'''

    def String plan(Plan plan, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (plan.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«plan.relativeDirectory»;
«ENDIF»

public class «plan.name»«plan.id» {
    public «plan.name»«plan.id»() {
        «constraintCodeGenerator.expressionsPlanCheckingMethods(plan)»
    }

    public Object getUtilityFunction(Plan plan) {
        // TODO: add Impl call here
    }

    «var List<State> states = plan.states»
    «FOR state: states»
        «constraintCodeGenerator.expressionsStateCheckingMethods(state)»
    «ENDFOR»
}
'''
}
