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

import de.unikassel.vs.alica.codegen.out.«behaviour.name»Impl;

public class «behaviour.name» {
    private «behaviour.name»Impl «behaviour.name»Impl = new «behaviour.name»Impl();

    public Object run() {
        this.«behaviour.name»Impl.run();
    }

    public Object initialiseParameters() {
        this.«behaviour.name»Impl.initialiseParameters();
    }
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
        ««constraintCodeGenerator.constraintBehaviourCheckingMethods(behaviour)»
    }
}
'''

    def String constraints(Plan plan, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (plan.relativeDirectory.isEmpty)»
#include "constraints/«plan.name»«plan.id»Constraints.h"
«ELSE»
#include "«plan.relativeDirectory»/constraints/«plan.name»«plan.id»Constraints.h"
«ENDIF»
/*PROTECTED REGION ID(ch«plan.id») ENABLED START*/
        «IF (protectedRegions.containsKey("ch" + plan.id))»
«protectedRegions.get("ch" + plan.id)»
        «ELSE»
            //Add additional options here
        «ENDIF»
/*PROTECTED REGION END*/

using namespace alica;

namespace alicaAutogenerated
{
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
    «FOR state : states»
        «constraintCodeGenerator.constraintStateCheckingMethods(state)»
	«ENDFOR»
}
'''

    def String domainBehaviour() '''
#include "DomainBehaviour.h"
/*PROTECTED REGION ID(domainBehaviourSrcHeaders) ENABLED START*/
«IF (protectedRegions.containsKey("domainBehaviourSrcHeaders"))»
«protectedRegions.get("domainBehaviourSrcHeaders")»
«ELSE»
//Add additional options here
«ENDIF»
/*PROTECTED REGION END*/

namespace alica
{
    DomainBehaviour::DomainBehaviour(std::string name) : BasicBehaviour(name)
    {
        /*PROTECTED REGION ID(domainBehaviourConstructor) ENABLED START*/
«IF (protectedRegions.containsKey("domainBehaviourConstructor"))»
«protectedRegions.get("domainBehaviourConstructor")»
«ELSE»
        //Add additional options here
«ENDIF»
        /*PROTECTED REGION END*/
    }

    DomainBehaviour::~DomainBehaviour()
    {
        /*PROTECTED REGION ID(domainBehaviourDestructor) ENABLED START*/
«IF (protectedRegions.containsKey("domainBehaviourDestructor"))»
«protectedRegions.get("domainBehaviourDestructor")»
«ELSE»
        //Add additional options here
«ENDIF»
        /*PROTECTED REGION END*/
    }

    /*PROTECTED REGION ID(domainBehaviourMethods) ENABLED START*/
«IF (protectedRegions.containsKey("domainBehaviourMethods"))»
«protectedRegions.get("domainBehaviourMethods")»
«ELSE»
    //Add additional options here
«ENDIF»
    /*PROTECTED REGION END*/
}
'''

    def String domainCondition() '''
#include "DomainCondition.h"
/*PROTECTED REGION ID(domainSourceHeaders) ENABLED START*/
«IF (protectedRegions.containsKey("domainSourceHeaders"))»
«protectedRegions.get("domainSourceHeaders")»
«ELSE»
        //Add additional options here
«ENDIF»
/*PROTECTED REGION END*/

namespace alica
{
    DomainCondition::DomainCondition() : BasicCondition()
    {
        /*PROTECTED REGION ID(domainSourceConstructor) ENABLED START*/
«IF (protectedRegions.containsKey("domainSourceConstructor"))»
«protectedRegions.get("domainSourceConstructor")»
«ELSE»
        //Add additional options here
«ENDIF»
        /*PROTECTED REGION END*/
    }

    DomainCondition::~DomainCondition()
    {
        /*PROTECTED REGION ID(domainSourceDestructor) ENABLED START*/
«IF (protectedRegions.containsKey("domainSourceDestructor"))»
«protectedRegions.get("domainSourceDestructor")»
«ELSE»
        //Add additional options here
«ENDIF»
        /*PROTECTED REGION END*/
    }

    /*PROTECTED REGION ID(additionalMethodsDomainCondition) ENABLED START*/
«IF (protectedRegions.containsKey("additionalMethodsDomainCondition"))»
«protectedRegions.get("additionalMethodsDomainCondition")»
«ELSE»
        //Add additional methods here
«ENDIF»
    /*PROTECTED REGION END*/
}
'''

    def String plan(Plan plan, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (plan.relativeDirectory.isEmpty)»
#include "«plan.name»«plan.id».h"
«ELSE»
#include "«plan.relativeDirectory»/«plan.name»«plan.id».h"
«ENDIF»
/*PROTECTED REGION ID(eph«plan.id») ENABLED START*/
«IF (protectedRegions.containsKey("eph" + plan.id))»
«protectedRegions.get("eph" + plan.id)»
«ELSE»
    //Add additional options here
«ENDIF»
/*PROTECTED REGION END*/

using namespace alica;

namespace alicaAutogenerated
{
    //Plan:«plan.name»
    «constraintCodeGenerator.expressionsPlanCheckingMethods(plan)»
    /* generated comment
        «var List<EntryPoint> entryPoints = plan.entryPoints»
        «FOR entryPoint : entryPoints»
        Task: «entryPoint.task.name»  -> EntryPoint-ID: «entryPoint.id»
        «ENDFOR»
    */
    shared_ptr<UtilityFunction> UtilityFunction«plan.id»::getUtilityFunction(Plan* plan)
    {
       /*PROTECTED REGION ID(«plan.id») ENABLED START*/
       «IF (protectedRegions.containsKey(plan.id))»
«protectedRegions.get(plan.id)»
       «ELSE»
            std::shared_ptr<UtilityFunction> defaultFunction = std::make_shared<DefaultUtilityFunction>(plan);
            return defaultFunction;
       «ENDIF»
        /*PROTECTED REGION END*/
    }
    «var List<State> states = plan.states»
    «FOR state : states»
		«constraintCodeGenerator.expressionsStateCheckingMethods(state)»
	«ENDFOR»
}
'''
}
