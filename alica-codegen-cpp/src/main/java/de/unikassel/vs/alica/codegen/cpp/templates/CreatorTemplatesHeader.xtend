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


class CreatorTemplatesHeader implements ICreatorTemplates {

    override String behaviourCreator(List<Behaviour> behaviours)'''
#pragma once

#include <engine/BasicBehaviour.h>
#include <engine/IBehaviourCreator.h>
#include <memory>
#include <iostream>

namespace alica {
    class BehaviourCreator: public IBehaviourCreator {
        public:
            BehaviourCreator();
            virtual ~BehaviourCreator();
            virtual std::shared_ptr<BasicBehaviour> createBehaviour(long behaviourId);
    };
}
'''

    override String utilityFunctionCreator(List<Plan> plans)'''
#pragma once

#include <engine/IUtilityCreator.h>
#include <memory>

namespace alica {
    class UtilityFunctionCreator: public IUtilityCreator {
        public:
            virtual ~UtilityFunctionCreator();
            UtilityFunctionCreator();
            std::shared_ptr<BasicUtilityFunction> createUtility(long utilityfunctionConfId);
    };
}
'''

    override String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
#pragma once

#include <engine/BasicCondition.h>
#include <engine/IConditionCreator.h>
#include <memory>
#include <iostream>

namespace alica {
    class ConditionCreator: public IConditionCreator {
        public:
            ConditionCreator();
            virtual ~ConditionCreator();
            std::shared_ptr<BasicCondition> createConditions(long conditionConfId);
    };
}
'''

    override String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
#pragma once

#include <engine/IConstraintCreator.h>
#include <memory>

namespace alica {
    class ConstraintCreator: public IConstraintCreator {
        public:
            ConstraintCreator();
            virtual ~ConstraintCreator();
            std::shared_ptr<BasicConstraint> createConstraint(long constraintConfId);
    };
}
'''

}
