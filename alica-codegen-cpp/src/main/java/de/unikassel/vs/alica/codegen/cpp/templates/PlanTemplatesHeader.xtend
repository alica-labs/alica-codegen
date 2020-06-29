package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition;
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

#include "Constraint«plan.preCondition.id»Impl.h"
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>
#include <engine/BasicConstraint.h>

namespace alica {
    class Constraint«plan.preCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«plan.preCondition.id»();
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);

        private:
            Constraint«plan.preCondition.id»Impl* impl;
    };
}
'''

    override String constraintPlanPreConditionImpl(Plan plan) '''
#pragma once

#include <engine/BasicConstraint.h>
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«plan.preCondition.id»Impl {
        public:
            static long id;
            Constraint«plan.preCondition.id»Impl();
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);
    };
}
'''

    override String constraintPlanRuntimeCondition(Plan plan) '''
#pragma once

#include "Constraint«plan.runtimeCondition.id»Impl.h"
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«plan.runtimeCondition.id»: public BasicConstraint {
        public:
            static long id;
            Constraint«plan.runtimeCondition.id»();
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);

        private:
            Constraint«plan.runtimeCondition.id»Impl* impl;
    };
}
'''

    override String constraintPlanRuntimeConditionImpl(Plan plan) '''
#pragma once

#include <engine/BasicConstraint.h>
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    class Constraint«plan.runtimeCondition.id»Impl {
        public:
            static long id;
            Constraint«plan.runtimeCondition.id»Impl();
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);
    };
}
'''

    override String utilityFunctionPlan(Plan plan) '''
#pragma once

#include "UtilityFunction1575724499793Impl.h"
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>
#include <engine/BasicPlan.h>
#include <engine/UtilityFunction.h>
#include <engine/BasicUtilityFunction.h>

namespace alica {
    class UtilityFunction«plan.id»: public BasicUtilityFunction {
        public:
            static long id;
            UtilityFunction«plan.id»();
            void getConstraint(ProblemDescriptor* c, RunningPlan* rp);

        private:
            UtilityFunction«plan.id»Impl* impl;
            UtilityFunction* getUtilityFunction(BasicPlan* plan);
    };
}
'''

    override String utilityFunctionPlanImpl(Plan plan) '''
#pragma once

#include <engine/BasicPlan.h>
#include <engine/UtilityFunction.h>
#include <engine/DefaultUtilityFunction.h>
#include <iostream>

namespace alica {
    class UtilityFunction«plan.id»Impl {
        public:
            static long id;
            UtilityFunction«plan.id»Impl();
            UtilityFunction* getUtilityFunction(BasicPlan* plan);
    };
}
'''

    override String preConditionPlan(Plan plan) '''
#pragma once

#include "DomainCondition.h"
#include "PreCondition1575724578855Impl.h"
#include <engine/RunningPlan.h>

namespace alica {
    class PreCondition«plan.preCondition.id»: public DomainCondition {
        public:
            static long id;
            PreCondition«plan.preCondition.id»(void* context);

        private:
            PreCondition«plan.preCondition.id»Impl* impl;
            bool evaluate(RunningPlan* rp);
    };
}
'''

    override String preConditionPlanImpl(Plan plan) '''
#pragma once

#include <engine/RunningPlan.h>
#include <iostream>

namespace alica {
    class PreCondition«plan.preCondition.id»Impl {
        public:
            static long id;
            PreCondition«plan.preCondition.id»Impl();
            bool evaluate(RunningPlan* rp);
    };
}
'''

    override String runtimeConditionPlan(Plan plan) '''
#pragma once

#include <engine/RunningPlan.h>

namespace alica {
    class RunTimeCondition«plan.runtimeCondition.id»: public DomainCondition {
        public:
            static long id;
            RunTimeCondition«plan.runtimeCondition.id»(void* context);

        private:
            RunTimeCondition«plan.runtimeCondition.id»Impl* impl;
            bool evaluate(RunningPlan* rp);
    };
}
'''

    override String runtimeConditionPlanImpl(Plan plan) '''
#pragma once

namespace alica {
    class RunTimeCondition«plan.runtimeCondition.id»Impl {
        public:
            static long id;
            RunTimeCondition«plan.runtimeCondition.id»Impl();
            bool evaluate(RunningPlan* rp);
    };
}
'''

}
