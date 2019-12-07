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
import de.unikassel.vs.alica.codegen.out.BehaviourCreator;
«FOR beh : behaviours»
    «IF (beh.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«StringUtils.capitalize(beh.name)»;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«beh.relativeDirectory».«StringUtils.capitalize(beh.name)»;
    «ENDIF»
«ENDFOR»

public class BehaviourCreator {
    public BasicBehaviour createBehaviour(long behaviourId) throws Exception {
        switch (behaviourId) {
            «FOR beh : behaviours»
                case «beh.id»L:
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

// import de.unikassel.vs.alica.codegen.out.impl.«StringUtils.capitalize(behaviour.name)»Impl;

public class «StringUtils.capitalize(behaviour.name)» {
    // private «StringUtils.capitalize(behaviour.name)»Impl «StringUtils.capitalize(behaviour.name)»Impl = new «StringUtils.capitalize(behaviour.name)»Impl();

    // public Object run() {
    //     this.«StringUtils.capitalize(behaviour.name)»Impl.run();
    // }

    // public Object initialiseParameters() {
    //     this.«StringUtils.capitalize(behaviour.name)»Impl.initialiseParameters();
    // }
}
'''

    def String utilityFunctionCreator(List<Plan> plans)'''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicUtilityFunction;
«FOR p: plans»
    «IF (p.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«StringUtils.capitalize(p.name)»«p.id»;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«p.relativeDirectory».«StringUtils.capitalize(p.name)»«p.id»;
    «ENDIF»
«ENDFOR»

public class UtilityFunctionCreator {
    public BasicUtilityFunction createUtility(long utilityfunctionConfId) throws Exception {
        switch(utilityfunctionConfId) {
            «FOR p: plans»
                case «p.id»L:
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
«FOR p: plans»
    «IF (p.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«StringUtils.capitalize(p.name)»«p.id»;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«p.relativeDirectory».«StringUtils.capitalize(p.name)»«p.id»;
    «ENDIF»
«ENDFOR»
«FOR b: behaviours»
    «IF (b.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«StringUtils.capitalize(b.name)»«b.id»;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«b.relativeDirectory».«StringUtils.capitalize(b.name)»«b.id»;
    «ENDIF»
«ENDFOR»

public class ConditionCreator {
    public BasicCondition createConditions(long conditionConfId) throws Exception {
        switch (conditionConfId) {
            «FOR con: conditions»
                case «con.id»L:
                    «IF (con instanceof PreCondition)»
                        return new PreCondition«con.id»();
                    «ENDIF»
                    «IF (con instanceof PostCondition)»
                        return new PostCondition«con.id»();
                    «ENDIF»
                    «IF (con instanceof RuntimeCondition)»
                        return new RunTimeCondition«con.id»();
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

import de.unikassel.vs.alica.engine.BasicCondition;
«FOR plan: plans»
    «IF (plan.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.constraints.«StringUtils.capitalize(plan.name)»«plan.id»Constraints;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«plan.relativeDirectory».constraints.«StringUtils.capitalize(plan.name)»«plan.id»Constraints;
    «ENDIF»
«ENDFOR»
«FOR behaviour: behaviours»
    «IF (behaviour.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.constraints.«StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints;
    «ELSE»
        import de.unikassel.vs.alica.codegen.out.«behaviour.relativeDirectory».constraints.«StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints;
    «ENDIF»
«ENDFOR»

public class ConstraintCreator {
    public BasicCondition createConstraint(long constraintConfId) throws Exception {
        switch (constraintConfId) {
            «FOR c: conditions»
                «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                    case «c.id»L:
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

public class «StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints {
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

public class «StringUtils.capitalize(plan.name)»«plan.id»Constraints {
    public «StringUtils.capitalize(plan.name)»«plan.id»Constraints() {

    }
}
'''

    def String domainBehaviour() '''
package de.unikassel.vs.alica.codegen.out;

public class DomainBehaviour {
}
'''

    def String domainCondition() '''
package de.unikassel.vs.alica.codegen.out;

public class DomainCondition {
}
'''

    def String plan(Plan plan, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (plan.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«plan.relativeDirectory»;
«ENDIF»
import de.unikassel.vs.alica.engine.BasePlan;
import de.unikassel.vs.alica.engine.BasicUtilityFunction;
import de.unikassel.vs.alica.codegen.out.impl.«StringUtils.capitalize(plan.name)»«plan.id»Impl;

public class «StringUtils.capitalize(plan.name)»«plan.id» extends BasePlan {
    private «StringUtils.capitalize(plan.name)»«plan.id»Impl planImpl = new «StringUtils.capitalize(plan.name)»«plan.id»Impl();

    public «StringUtils.capitalize(plan.name)»«plan.id»() {
        «constraintCodeGenerator.expressionsPlanCheckingMethods(plan)»
    }

    public BasicUtilityFunction getUtilityFunction(Plan plan) {
        return planImpl.getUtilityFunction(plan);
    }

    «var List<State> states = plan.states»
    «FOR state: states»
        «constraintCodeGenerator.expressionsStateCheckingMethods(state)»
    «ENDFOR»
}
'''

    def String planImpl(Plan plan) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.BasePlan;
import de.unikassel.vs.alica.engine.BasicUtilityFunction;
import de.unikassel.vs.alica.engine.DefaultUtilityFunction;

public class «StringUtils.capitalize(plan.name)»«plan.id»Impl {
    public BasicUtilityFunction getUtilityFunction(BasePlan plan) {
        return new DefaultUtilityFunction();
    }
}
'''
}
