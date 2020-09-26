package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.IPlanTemplates;


class PlanTemplatesHeader implements IPlanTemplates {

    override String constraints(Plan plan) '''
#pragma once

namespace alica {
    class «StringUtils.capitalize(plan.name)»«plan.id»Constraints {
        public:
            static long id;
    };
}
'''

    override String constraintPlanPreCondition(Plan plan) '''
#pragma once

#include <memory>
#include <engine/BasicConstraint.h>

namespace alica {
    class Constraint«plan.preCondition.id»Impl;

    class ProblemDescriptor;

    class RunningPlan;

    class Constraint«plan.preCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«plan.preCondition.id»();
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);

        private:
            std::shared_ptr<Constraint«plan.preCondition.id»Impl> impl;
    };
}
'''

    override String constraintPlanPreConditionImpl(Plan plan) '''
#pragma once

#include <memory>

namespace alica {
    class ProblemDescriptor;

    class RunningPlan;

    class Constraint«plan.preCondition.id»Impl {
        public:
            static long id;
            Constraint«plan.preCondition.id»Impl();
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String constraintPlanRuntimeCondition(Plan plan) '''
#pragma once

#include <memory>
#include <engine/BasicConstraint.h>

namespace alica {
    class Constraint«plan.runtimeCondition.id»Impl;

    class ProblemDescriptor;

    class RunningPlan;

    class Constraint«plan.runtimeCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«plan.runtimeCondition.id»();
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);

        private:
            std::shared_ptr<Constraint«plan.runtimeCondition.id»Impl> impl;
    };
}
'''

    override String constraintPlanRuntimeConditionImpl(Plan plan) '''
#pragma once

#include <memory>

namespace alica {
    class ProblemDescriptor;

    class RunningPlan;

    class Constraint«plan.runtimeCondition.id»Impl {
        public:
            static long id;
            Constraint«plan.runtimeCondition.id»Impl();
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String utilityFunctionPlan(Plan plan) '''
#pragma once

#include <memory>
#include <engine/BasicUtilityFunction.h>

namespace alica {
    class ProblemDescriptor;

    class RunningPlan;

    class BasicPlan;

    class UtilityFunction;

    class UtilityFunction«plan.id»Impl;

    class UtilityFunction«plan.id»: public BasicUtilityFunction {
        public:
            static long id;
            UtilityFunction«plan.id»();
            void getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp);

        private:
            std::shared_ptr<UtilityFunction«plan.id»Impl> impl;
            std::shared_ptr<UtilityFunction> getUtilityFunction(BasicPlan* plan);
    };
}
'''

    override String utilityFunctionPlanImpl(Plan plan) '''
#pragma once

#include <memory>

namespace alica {
    class BasicPlan;

    class UtilityFunction;

    class UtilityFunction«plan.id»Impl {
        public:
            static long id;
            UtilityFunction«plan.id»Impl();
            std::shared_ptr<UtilityFunction> getUtilityFunction(BasicPlan* plan);
    };
}
'''

    override String preConditionPlan(Plan plan) '''
#pragma once

#include <memory>
#include "domain/DomainCondition.h"

namespace alica {
    class PreCondition«plan.preCondition.id»Impl;

    class RunningPlan;

    class PreCondition«plan.preCondition.id»: public DomainCondition {
        public:
            static long id;
            PreCondition«plan.preCondition.id»(void* context);

        private:
            std::shared_ptr<PreCondition«plan.preCondition.id»Impl> impl;
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String preConditionPlanImpl(Plan plan) '''
#pragma once

#include <memory>

namespace alica {
    class RunningPlan;

    class PreCondition«plan.preCondition.id»Impl {
        public:
            static long id;
            PreCondition«plan.preCondition.id»Impl();
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String runtimeConditionPlan(Plan plan) '''
#pragma once

#include <memory>
#include <engine/RunningPlan.h>

namespace alica {
    class RunTimeCondition«plan.runtimeCondition.id»: public DomainCondition {
        public:
            static long id;
            RunTimeCondition«plan.runtimeCondition.id»(void* context);

        private:
            std::shared_ptr<RunTimeCondition«plan.runtimeCondition.id»Impl> impl;
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

    override String runtimeConditionPlanImpl(Plan plan) '''
#pragma once

#include <memory>

namespace alica {
    class RunTimeCondition«plan.runtimeCondition.id»Impl {
        public:
            static long id;
            RunTimeCondition«plan.runtimeCondition.id»Impl();
            bool evaluate(std::shared_ptr<RunningPlan> rp);
    };
}
'''

}
