package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition;
import de.unikassel.vs.alica.planDesigner.alicamodel.State;
import de.unikassel.vs.alica.codegen.templates.ITransitionTemplates;


class TransitionTemplatesHeader implements ITransitionTemplates {

    override String constraintPlanTransitionPreCondition(Plan plan, Transition transition) '''
#pragma once

#include <memory>
#include <engine/BasicConstraint.h>

namespace alica {
    class Constraint«transition.preCondition.id»Impl;

    class ProblemDescriptor;

    class RunningPlan;

    class Constraint«transition.preCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«transition.preCondition.id»();

        private:
            std::shared_ptr<Constraint«transition.preCondition.id»Impl> impl;
            void getConstraint(std::std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String constraintPlanTransitionPreConditionImpl(Transition transition) '''
#pragma once

#include <memory>

namespace alica {
    class Constraint«transition.preCondition.id»Impl {
        public:
            static long id;
            Constraint«transition.preCondition.id»Impl();

        private:
            void getConstraint(std::std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String transitionPreConditionPlan(State state, Transition transition) '''
#pragma once

#include <memory>

namespace alica {
    class PreCondition«transition.preCondition.id»: public DomainCondition {
        public:
            static long id;
            PreCondition«transition.preCondition.id»(void* context);

        private:
            std::shared_ptr<PreCondition«transition.preCondition.id»Impl> impl;
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String transitionPreConditionPlanImpl(Transition transition) '''
#pragma once

#include <memory>
#include <iostream>
#include "domain/DomainCondition.h"

namespace alica {
    class PreCondition«transition.preCondition.id»Impl {
        public:
            static long id;
            PreCondition«transition.preCondition.id»Impl(std::std::shared_ptr<DomainCondition> condition);

        private:
            std::shared_ptr<DomainCondition> condition;
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

}
