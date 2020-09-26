package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition;
import de.unikassel.vs.alica.planDesigner.alicamodel.State;
import de.unikassel.vs.alica.codegen.templates.ITransitionTemplates;


class TransitionTemplatesSource implements ITransitionTemplates {

    override String constraintPlanTransitionPreCondition(Plan plan, Transition transition) '''
#include "constraints/Constraint«transition.preCondition.id».h"
#include "constraints/Constraint«transition.preCondition.id»Impl.h"
#include <engine/BasicConstraint.h>
#include <engine/ProblemDescriptor.h>
#include <engine/RunningPlan.h>

namespace alica {
    long Constraint«transition.preCondition.id»::id = «transition.preCondition.id»;

    Constraint«transition.preCondition.id»::Constraint«transition.preCondition.id»(): BasicConstraint() {
        this -> impl = std::make_shared<Constraint«transition.preCondition.id»Impl>();
    }

    void Constraint«transition.preCondition.id»::getConstraint(std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp) {
        this -> impl -> getConstraint(c, rp);
    }
}


'''

    override String constraintPlanTransitionPreConditionImpl(Transition transition) '''
namespace alica {
    long Constraint«transition.preCondition.id»Impl::id = «transition.preCondition.id»;

    Constraint«transition.preCondition.id»Impl::Constraint«transition.preCondition.id»Impl() {

    }

    void Constraint«transition.preCondition.id»Impl::getConstraint(std::std::shared_ptr<ProblemDescriptor> c, std::shared_ptr<RunningPlan> rp) {

    }
}
'''

    override String transitionPreConditionPlan(State state, Transition transition) '''
#include "conditions/PreCondition«transition.preCondition.id».h"
#include "conditions/PreCondition«transition.preCondition.id»Impl.h"
#include <engine/RunningPlan.h>

namespace alica {
    long PreCondition«transition.preCondition.id»::id = «transition.preCondition.id»;

    PreCondition«transition.preCondition.id»::PreCondition«transition.preCondition.id»(void* context): DomainCondition(context) {
        this -> impl = std::make_shared<PreCondition«transition.preCondition.id»Impl>();
    }

    bool PreCondition«transition.preCondition.id»::evaluate(std::shared_ptr<RunningPlan> rp) {
        return this -> impl -> evaluate(rp);
    }
}
'''

    override String transitionPreConditionPlanImpl(Transition transition) '''
#include <iostream>

namespace alica {
    long PreCondition«transition.preCondition.id»Impl::id = «transition.preCondition.id»;

    PreCondition«transition.preCondition.id»Impl::PreCondition«transition.preCondition.id»Impl(std::shared_ptr<DomainCondition> condition) {
        this -> condition = condition;
    }

    bool PreCondition«transition.preCondition.id»Impl::evaluate(std::shared_ptr<RunningPlan> rp) {
        std::cerr << "The PreCondition " << this -> id << " in Transition «transition.getName» is not implement yet!" << std::endl;
        return false;
    }
}
'''

}
