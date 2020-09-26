package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.RuntimeCondition;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.ICreatorTemplates;


class CreatorTemplatesSource implements ICreatorTemplates {

    override String behaviourCreator(List<Behaviour> behaviours)'''
#include "creators/BehaviourCreator.h"
«FOR behaviour: behaviours»
    «IF (behaviour.relativeDirectory.isEmpty)»
        #include "behaviours/«StringUtils.capitalize(behaviour.name)».h"
    «ELSE»
        #include "behaviours/«behaviour.relativeDirectory»/«StringUtils.capitalize(behaviour.name)».h"
    «ENDIF»
«ENDFOR»
#include <engine/BasicBehaviour.h>
#include <iostream>

namespace alica {
    BehaviourCreator::BehaviourCreator() {

    }

    BehaviourCreator::~BehaviourCreator() {

    }

    BasicBehaviour* BehaviourCreator::createBehaviour(long behaviourId, void* context) {
        switch(behaviourId) {
            «FOR beh: behaviours»
                case «beh.id»:
                    return new «StringUtils.capitalize(beh.name)»(context);
            «ENDFOR»
            default:
                std::cerr << "BehaviourCreator: Unknown behaviour requested: " << behaviourId << std::endl;
                return nullptr;
        }
    }
}
'''

    override String utilityFunctionCreator(List<Plan> plans)'''
«FOR p: plans»
    #include "utilityfunctions/UtilityFunction«p.id».h"
«ENDFOR»
#include "creators/UtilityFunctionCreator.h"
#include <iostream>

namespace alica {
    UtilityFunctionCreator::~UtilityFunctionCreator() {
    }

    UtilityFunctionCreator::UtilityFunctionCreator() {
    }

    BasicUtilityFunction* UtilityFunctionCreator::createUtility(long utilityFunctionConfId) {
        switch(utilityFunctionConfId) {
            «FOR p: plans»
                case «p.id»:
                    return new UtilityFunction«p.id»();
            «ENDFOR»
            default:
                std::cerr << "UtilityFunctionCreator: Unknown utility requested: " << utilityFunctionConfId << std::endl;
                return nullptr;
        }
    }
}
'''

    override String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
«FOR con: conditions»
    «IF (con instanceof PreCondition)»
        #include "conditions/PreCondition«con.id».h"
    «ENDIF»
    «IF (con instanceof PostCondition)»
        #include "conditions/PostCondition«con.id».h"
    «ENDIF»
    «IF (con instanceof RuntimeCondition)»
        #include "conditions/RunTimeCondition«con.id».h"
    «ENDIF»
«ENDFOR»
#include "creators/ConditionCreator.h"
#include <engine/BasicCondition.h>
#include <iostream>

namespace alica{
    ConditionCreator::ConditionCreator() {
    }

    ConditionCreator::~ConditionCreator() {
    }

    BasicCondition* ConditionCreator::createConditions(long conditionConfId, void* context) {
        switch (conditionConfId) {
            «FOR con: conditions»
                case «con.id»:
                    «IF (con instanceof PreCondition)»
                        return new PreCondition«con.id»(context);
                    «ENDIF»
                    «IF (con instanceof PostCondition)»
                        return new PostCondition«con.id»(context);
                    «ENDIF»
                    «IF (con instanceof RuntimeCondition)»
                        return new RunTimeCondition«con.id»(context);
                    «ENDIF»
            «ENDFOR»
            default:
                std::cerr << "ConditionCreator: Unknown condition id requested: " << conditionConfId << std::endl;
                return nullptr;
        }
    }
}
'''

    override String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
#include "creators/ConstraintCreator.h"

namespace alica {
    ConstraintCreator::ConstraintCreator() {
    }

    ConstraintCreator::~ConstraintCreator() {
    }

    BasicConstraint* ConstraintCreator::createConstraint(long constraintConfId) {
        switch(constraintConfId) {
            «FOR c: conditions»
                «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                    case «c.id»:
                        return new Constraint«c.id»();
                «ENDIF»
            «ENDFOR»
            default:
                std::cerr << "ConstraintCreator: Unknown constraint requested: " << constraintConfId << std::endl;
                return nullptr;
        }
    }
}
'''

}
