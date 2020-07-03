package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition;
import de.unikassel.vs.alica.planDesigner.alicamodel.State;
import de.unikassel.vs.alica.codegen.templates.ITransitionTemplates;


class TransitionTemplatesHeader implements ITransitionTemplates {

    override String constraintPlanTransitionPreCondition(Plan plan, Transition transition) '''
#pragma once

#include "Constraint«transition.preCondition.id»Impl.h"
#include <engine/BasicConstraint.h>
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«transition.preCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«transition.preCondition.id»();

        private:
            Constraint«transition.preCondition.id»Impl* impl;
            void getConstraint(std::ProblemDescriptor* c, RunningPlan* rp);
    };
}
'''

    override String constraintPlanTransitionPreConditionImpl(Transition transition) '''
#pragma once

namespace alica {
    class Constraint«transition.preCondition.id»Impl {
        public:
            static long id;
            Constraint«transition.preCondition.id»Impl();

        private:
            void getConstraint(std::ProblemDescriptor* c, RunningPlan* rp);
    };
}
'''

    override String transitionPreConditionPlan(State state, Transition transition) '''
#pragma once

namespace alica {
    class PreCondition«transition.preCondition.id»: public DomainCondition {
        public:
            static long id;
            PreCondition«transition.preCondition.id»(void* context);

        private:
            PreCondition«transition.preCondition.id»Impl* impl;
            bool evaluate(RunningPlan* rp);
    };
}
'''

    override String transitionPreConditionPlanImpl(Transition transition) '''
#pragma once

#include "DomainCondition.h"
#include <iostream>

namespace alica {
    class PreCondition«transition.preCondition.id»Impl {
        public:
            static long id;
            PreCondition«transition.preCondition.id»Impl(std::DomainCondition* condition);

        private:
            DomainCondition* condition;
            bool evaluate(RunningPlan* rp);
    };
}
'''

}
