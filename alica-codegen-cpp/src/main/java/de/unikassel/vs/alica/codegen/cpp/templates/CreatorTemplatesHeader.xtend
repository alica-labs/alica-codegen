package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import java.util.List;
import de.unikassel.vs.alica.codegen.templates.ICreatorTemplates;


class CreatorTemplatesHeader implements ICreatorTemplates {

    override String behaviourCreator(List<Behaviour> behaviours)'''
#pragma once

#include <memory>
#include <engine/IBehaviourCreator.h>

namespace alica {
    class BasicBehaviour;

    class BehaviourCreator: public IBehaviourCreator {
        public:
            BehaviourCreator();
            virtual ~BehaviourCreator();
            virtual std::shared_ptr<BasicBehaviour> createBehaviour(int64_t behaviourId, void* context);
    };
}
'''

    override String utilityFunctionCreator(List<Plan> plans)'''
#pragma once

#include <memory>
#include <engine/IUtilityCreator.h>

namespace alica {
    class BasicUtilityFunction;

    class UtilityFunctionCreator: public IUtilityCreator {
        public:
            UtilityFunctionCreator();
            virtual ~UtilityFunctionCreator();
            virtual std::shared_ptr<BasicUtilityFunction> createUtility(int64_t utilityFunctionConfId);
    };
}
'''

    override String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
#pragma once

#include <memory>
#include <engine/IConditionCreator.h>

namespace alica {
    class BasicCondition;

    class ConditionCreator: public IConditionCreator {
        public:
            ConditionCreator();
            virtual ~ConditionCreator();
            std::shared_ptr<BasicCondition> createConditions(int64_t conditionConfId, void* context);
    };
}
'''

    override String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
#pragma once

#include <memory>
#include <iostream>
#include <engine/IConstraintCreator.h>
#include <engine/BasicConstraint.h>

namespace alica {
    class ConstraintCreator: public IConstraintCreator {
        public:
            ConstraintCreator();
            virtual ~ConstraintCreator();
            virtual std::shared_ptr<BasicConstraint> createConstraint(int64_t constraintConfId);
    };
}
'''

}
