package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.IPlanTemplates;


class PlanTemplatesSource implements IPlanTemplates {

    override String constraints(Plan plan) '''
«IF (plan.relativeDirectory.isEmpty)»
    #include "constraints/«StringUtils.capitalize(plan.name)»«plan.id»Constraints.h"
«ELSE»
    #include "constraints/«plan.relativeDirectory»/«StringUtils.capitalize(plan.name)»«plan.id»Constraints.h"
«ENDIF»

namespace alica {
    long «StringUtils.capitalize(plan.name)»«plan.id»Constraints::id = «plan.id»;
}
'''

    override String constraintPlanPreCondition(Plan plan) '''
#include "constraints/Constraint«plan.preCondition.id».h"
#include "constraints/Constraint«plan.preCondition.id»Impl.h"

namespace alica {
    long Constraint«plan.preCondition.id»::id = «plan.preCondition.id»;

    Constraint«plan.preCondition.id»::Constraint«plan.preCondition.id»(): BasicConstraint() {
        this -> impl = new Constraint«plan.preCondition.id»Impl();
    }

    void Constraint«plan.preCondition.id»::getConstraint(ProblemDescriptor* c, RunningPlan* rp) {
        this -> impl -> getConstraint(c, rp);
    }
}

'''

    override String constraintPlanPreConditionImpl(Plan plan) '''
#include "constraints/Constraint«plan.preCondition.id»Impl.h"
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    long Constraint«plan.preCondition.id»Impl::id = «plan.preCondition.id»;

    Constraint«plan.preCondition.id»Impl::Constraint«plan.preCondition.id»Impl() {

    }

    void Constraint«plan.preCondition.id»Impl::getConstraint(ProblemDescriptor* c, RunningPlan* rp) {

    }
}
'''

    override String constraintPlanRuntimeCondition(Plan plan) '''
#include "constraints/Constraint«plan.runtimeCondition.id».h"
#include "constraints/Constraint«plan.runtimeCondition.id»Impl.h"
#include <engine/BasicConstraint.h>
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    long Constraint«plan.runtimeCondition.id»::id = «plan.runtimeCondition.id»;

    Constraint«plan.runtimeCondition.id»::Constraint«plan.runtimeCondition.id»(): BasicConstraint() {
        this -> impl = new Constraint«plan.runtimeCondition.id»Impl();
    }

    void Constraint«plan.runtimeCondition.id»::getConstraint(ProblemDescriptor* c, RunningPlan* rp) {
        this -> impl -> getConstraint(c, rp);
    }
}
'''

    override String constraintPlanRuntimeConditionImpl(Plan plan) '''
#include "constraints/Constraint«plan.runtimeCondition.id»Impl.h"
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    long Constraint«plan.runtimeCondition.id»Impl::id = «plan.runtimeCondition.id»;

    Constraint«plan.runtimeCondition.id»Impl::Constraint«plan.runtimeCondition.id»Impl() {

    }

    void Constraint«plan.runtimeCondition.id»Impl::getConstraint(ProblemDescriptor* c, RunningPlan* rp) {

    }
}
'''

    override String utilityFunctionPlan(Plan plan) '''
#include "utilityfunctions/UtilityFunction«plan.id».h"
#include "utilityfunctions/UtilityFunction«plan.id»Impl.h"
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>
#include <engine/BasicPlan.h>
#include <engine/UtilityFunction.h>

namespace alica {
    long UtilityFunction«plan.id»::id = «plan.id»;

    UtilityFunction«plan.id»::UtilityFunction«plan.id»(): BasicUtilityFunction() {
        this -> impl = new UtilityFunction«plan.id»Impl();
    }

    UtilityFunction* UtilityFunction«plan.id»::getUtilityFunction(BasicPlan* plan) {
        return this -> impl -> getUtilityFunction(plan);
    }
}
'''

    override String utilityFunctionPlanImpl(Plan plan) '''
#include "utilityfunctions/UtilityFunction«plan.id»Impl.h"
#include <engine/BasicPlan.h>
#include <engine/UtilityFunction.h>
#include <engine/DefaultUtilityFunction.h>
#include <iostream>

namespace alica {
    long UtilityFunction«plan.id»Impl::id = «plan.id»;

    UtilityFunction«plan.id»Impl::UtilityFunction«plan.id»Impl() {

    }

    UtilityFunction* UtilityFunction«plan.id»Impl::getUtilityFunction(BasicPlan* plan) {
        return new DefaultUtilityFunction(plan);
    }
}
'''

    override String preConditionPlan(Plan plan) '''
#include "conditions/PreCondition«plan.preCondition.id».h"
#include "conditions/PreCondition«plan.preCondition.id»Impl.h"
#include <engine/RunningPlan.h>

namespace alica {
    long PreCondition«plan.preCondition.id»::id = «plan.preCondition.id»;

    PreCondition«plan.preCondition.id»::PreCondition«plan.preCondition.id»(void* context): DomainCondition(context) {
        this -> impl = new PreCondition«plan.preCondition.id»Impl();
    }

    bool PreCondition«plan.preCondition.id»::evaluate(RunningPlan* rp) {
        return this -> impl -> evaluate(rp);
    }
}
'''

    override String preConditionPlanImpl(Plan plan) '''
#include "conditions/PreCondition«plan.preCondition.id».h"
#include "conditions/PreCondition«plan.preCondition.id»Impl.h"
#include <engine/RunningPlan.h>
#include <iostream>

namespace alica {
    long PreCondition«plan.preCondition.id»Impl::id = «plan.preCondition.id»;

    PreCondition«plan.preCondition.id»Impl::PreCondition«plan.preCondition.id»Impl() {

    }

    bool PreCondition«plan.preCondition.id»Impl::evaluate(RunningPlan* rp) {
        std::cerr << "The PreCondition " << id << " in Plan «plan.getName» is not implement yet!" << std::endl;
        return false;
    }
}
'''

    override String runtimeConditionPlan(Plan plan) '''
#include "conditions/RunTimeCondition«plan.runtimeCondition.id».h"
#include "conditions/RunTimeCondition«plan.runtimeCondition.id»Impl.h"
#include <engine/RunningPlan.h>

namespace alica {
    long RunTimeCondition«plan.runtimeCondition.id»::id = «plan.runtimeCondition.id»;

    RunTimeCondition«plan.runtimeCondition.id»::RunTimeCondition«plan.runtimeCondition.id»(void* context): DomainCondition(context) {
        this -> impl = new RunTimeCondition«plan.runtimeCondition.id»Impl();
    }

    bool RunTimeCondition«plan.runtimeCondition.id»::evaluate(RunningPlan* rp) {
        return this -> impl -> evaluate(rp);
    }
}
'''

    override String runtimeConditionPlanImpl(Plan plan) '''
#include <iostream>

namespace alica {
    long RunTimeCondition«plan.runtimeCondition.id»Impl::id = «plan.runtimeCondition.id»;

    RunTimeCondition«plan.runtimeCondition.id»Impl::RunTimeCondition«plan.runtimeCondition.id»Impl() {

    }

    bool RunTimeCondition«plan.runtimeCondition.id»Impl::evaluate(RunningPlan* rp) {
        std::cerr << "The RunTimeCondition " << id << " is not implement yet!" << std::endl;
        return false;
    }
}
'''

}
