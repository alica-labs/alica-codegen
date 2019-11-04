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
#include "BehaviourCreator.h"
#include "engine/BasicBehaviour.h"
«FOR beh : behaviours»
«IF (beh.relativeDirectory.isEmpty)»
#include "«beh.name».h"
«ELSE»
#include  "«beh.relativeDirectory»/«beh.name».h"
«ENDIF»
«ENDFOR»

namespace alica
{

    BehaviourCreator::BehaviourCreator()
    {
    }

    BehaviourCreator::~BehaviourCreator()
    {
    }

    std::shared_ptr<BasicBehaviour> BehaviourCreator::createBehaviour(long behaviourId)
    {
        switch(behaviourId)
        {
            «FOR beh : behaviours»
                case «beh.id»:
                return std::make_shared<«beh.name»>();
                break;
            «ENDFOR»
            default:
            std::cerr << "BehaviourCreator: Unknown behaviour requested: " << behaviourId << std::endl;
            throw new std::exception();
            break;
        }
    }
}
'''

    def String behaviour(Behaviour behaviour) '''
«IF (behaviour.relativeDirectory.isEmpty)»
#include "«behaviour.name».h"
«ELSE»
#include  "«behaviour.relativeDirectory»/«behaviour.name».h"
«ENDIF»
#include <memory>

/*PROTECTED REGION ID(inccpp«behaviour.id») ENABLED START*/
    «IF (protectedRegions.containsKey("inccpp" + behaviour.id))»
«protectedRegions.get("inccpp" + behaviour.id)»
    «ELSE»
        //Add additional includes here
    «ENDIF»
/*PROTECTED REGION END*/

namespace alica
{
    /*PROTECTED REGION ID(staticVars«behaviour.id») ENABLED START*/
    «IF (protectedRegions.containsKey("staticVars" + behaviour.id))»
«protectedRegions.get("staticVars" + behaviour.id)»
    «ELSE»
        //initialise static variables here
    «ENDIF»
    /*PROTECTED REGION END*/

    «behaviour.name»::«behaviour.name»() : DomainBehaviour("«behaviour.name»")
    {
        /*PROTECTED REGION ID(con«behaviour.id») ENABLED START*/
        «IF (protectedRegions.containsKey("con" + behaviour.id))»
«protectedRegions.get("con" + behaviour.id)»
        «ELSE»
            //Add additional options here
        «ENDIF»
        /*PROTECTED REGION END*/

    }
    «behaviour.name»::~«behaviour.name»()
    {
        /*PROTECTED REGION ID(dcon«behaviour.id») ENABLED START*/
        «IF (protectedRegions.containsKey("dcon" + behaviour.id))»
«protectedRegions.get("dcon" + behaviour.id)»
        «ELSE»
            //Add additional options here
        «ENDIF»
        /*PROTECTED REGION END*/

    }
    void «behaviour.name»::run(void* msg)
    {
        /*PROTECTED REGION ID(run«behaviour.id») ENABLED START*/
        «IF (protectedRegions.containsKey("run" + behaviour.id))»
«protectedRegions.get("run" + behaviour.id)»
        «ELSE»
            //Add additional options here
        «ENDIF»
        /*PROTECTED REGION END*/

    }
    void «behaviour.name»::initialiseParameters()
    {
        /*PROTECTED REGION ID(initialiseParameters«behaviour.id») ENABLED START*/
        «IF (protectedRegions.containsKey("initialiseParameters" + behaviour.id))»
«protectedRegions.get("initialiseParameters" + behaviour.id)»
        «ELSE»
            //Add additional options here
        «ENDIF»

        /*PROTECTED REGION END*/

    }
    /*PROTECTED REGION ID(methods«behaviour.id») ENABLED START*/
        «IF (protectedRegions.containsKey("methods" + behaviour.id))»
«protectedRegions.get("methods" + behaviour.id)»
        «ELSE»
            //Add additional options here
        «ENDIF»
    /*PROTECTED REGION END*/

} /* namespace alica */
'''

    def String utilityFunctionCreator(List<Plan> plans)'''
#include "UtilityFunctionCreator.h"
«FOR p : plans»
«IF (p.relativeDirectory.isEmpty)»
#include "«p.name»«p.id».h"
«ELSE»
#include  "«p.relativeDirectory»/«p.name»«p.id».h"
«ENDIF»
«ENDFOR»
#include <iostream>

using namespace alicaAutogenerated;

namespace alica
{

    UtilityFunctionCreator::~UtilityFunctionCreator()
    {
    }

    UtilityFunctionCreator::UtilityFunctionCreator()
    {
    }


    std::shared_ptr<BasicUtilityFunction> UtilityFunctionCreator::createUtility(long utilityfunctionConfId)
    {
        switch(utilityfunctionConfId)
        {
            «FOR p : plans»
            case «p.id»:
                return std::make_shared<UtilityFunction«p.id»>();
                break;
            «ENDFOR»
            default:
            std::cerr << "UtilityFunctionCreator: Unknown utility requested: " << utilityfunctionConfId << std::endl;
            throw new std::exception();
            break;
        }
    }


}
'''

    def String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
#include "ConditionCreator.h"
«FOR p : plans»
«IF (p.relativeDirectory.isEmpty)»
#include "«p.name»«p.id».h"
«ELSE»
#include  "«p.relativeDirectory»/«p.name»«p.id».h"
«ENDIF»
«ENDFOR»
«FOR b : behaviours»
«IF (b.relativeDirectory.isEmpty)»
#include "«b.name»«b.id».h"
«ELSE»
#include  "«b.relativeDirectory»/«b.name»«b.id».h"
«ENDIF»
«ENDFOR»

using namespace alicaAutogenerated;
namespace alica
{

    ConditionCreator::ConditionCreator()
    {
    }
    ConditionCreator::~ConditionCreator()
    {
    }

    std::shared_ptr<BasicCondition> ConditionCreator::createConditions(long conditionConfId)
    {
        switch (conditionConfId)
        {
            «FOR con : conditions»
            case «con.id»:
            «IF (con instanceof PreCondition)»
                    return std::make_shared<PreCondition«con.id»>();
            «ENDIF»
            «IF (con instanceof PostCondition)»
                return std::make_shared<PostCondition«con.id»>();
            «ENDIF»
            «IF (con instanceof RuntimeCondition)»
                return std::make_shared<RunTimeCondition«con.id»>();
            «ENDIF»
                break;
            «ENDFOR»
            default:
            std::cerr << "ConditionCreator: Unknown condition id requested: " << conditionConfId << std::endl;
            throw new std::exception();
            break;
        }
    }
}
'''

    def String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
#include "ConstraintCreator.h"

«FOR plan : plans»
«IF (plan.relativeDirectory.isEmpty)»
#include "constraints/«plan.name»«plan.id»Constraints.h"
«ELSE»
#include "«plan.relativeDirectory»/constraints/«plan.name»«plan.id»Constraints.h"
«ENDIF»
«ENDFOR»
«FOR behaviour : behaviours»
«IF (behaviour.relativeDirectory.isEmpty)»
#include "constraints/«behaviour.name»«behaviour.id»Constraints.h"
«ELSE»
#include "«behaviour.relativeDirectory»/constraints/«behaviour.name»«behaviour.id»Constraints.h"
«ENDIF»
«ENDFOR»

#include <iostream>

using namespace alicaAutogenerated;

namespace alica
{

    ConstraintCreator::ConstraintCreator()
    {
    }

    ConstraintCreator::~ConstraintCreator()
    {
    }


    shared_ptr<BasicConstraint> ConstraintCreator::createConstraint(long constraintConfId)
    {
        switch(constraintConfId)
        {
            «FOR c : conditions»
                «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                    case «c.id»:
                    return std::make_shared<Constraint«c.id»>();
                    break;
                «ENDIF»
            «ENDFOR»
            default:
            std::cerr << "ConstraintCreator: Unknown constraint requested: " << constraintConfId << std::endl;
            throw new std::exception();
            break;
        }
    }


}
'''

    def String behaviourCondition(Behaviour behaviour, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (behaviour.relativeDirectory.isEmpty)»
#include "«behaviour.name»«behaviour.id».h"
«ELSE»
#include  "«behaviour.relativeDirectory»/«behaviour.name»«behaviour.id».h"
«ENDIF»
#include <memory>

/*PROTECTED REGION ID(inccppBC«behaviour.id») ENABLED START*/
    «IF (protectedRegions.containsKey("inccppBC" + behaviour.id))»
«protectedRegions.get("inccppBC" + behaviour.id)»
    «ELSE»
        //Add additional includes here
    «ENDIF»
/*PROTECTED REGION END*/

using namespace alica;

namespace alicaAutogenerated
{
    //Behaviour:«behaviour.name»
    «constraintCodeGenerator.expressionsBehaviourCheckingMethods(behaviour)»

} /* namespace alica */
'''

    def String constraints(Behaviour behaviour, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (behaviour.relativeDirectory.isEmpty)»
#include "constraints/«behaviour.name»«behaviour.id»Constraints.h"
«ELSE»
#include "«behaviour.relativeDirectory»/constraints/«behaviour.name»«behaviour.id»Constraints.h"
«ENDIF»
/*PROTECTED REGION ID(ch«behaviour.id») ENABLED START*/
        «IF (protectedRegions.containsKey("ch" + behaviour.id))»
«protectedRegions.get("ch" + behaviour.id)»
        «ELSE»
            //Add additional options here
        «ENDIF»
/*PROTECTED REGION END*/

using namespace alica;

namespace alicaAutogenerated
{

    //Behaviour:«behaviour.name»
     «constraintCodeGenerator.constraintBehaviourCheckingMethods(behaviour)»
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
} /* namespace alica */
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
} /* namespace alica */
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
