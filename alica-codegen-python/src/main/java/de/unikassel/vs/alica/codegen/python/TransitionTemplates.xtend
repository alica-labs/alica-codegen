package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import java.util.List;
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition;
import de.unikassel.vs.alica.planDesigner.alicamodel.State;
import de.unikassel.vs.alica.planDesigner.alicamodel.Variable;
import de.unikassel.vs.alica.codegen.templates.ITransitionTemplates;


class TransitionTemplates implements ITransitionTemplates {

    override String constraintPlanTransitionPreCondition(Plan plan, Transition transition) '''
from engine import BasicConstraint, ProblemDescriptor, RunningPlan
from impl.constraints.constraint_«transition.preCondition.id»_impl import Constraint«transition.preCondition.id»Impl


class Constraint«transition.preCondition.id»(BasicConstraint):
    id_ = «transition.preCondition.id»

    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«transition.preCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        self.impl.get_constraint(problem_descriptor, running_plan)
'''

    override String constraintPlanTransitionPreConditionImpl(Transition transition) '''
from engine import ProblemDescriptor, RunningPlan


class Constraint«transition.preCondition.id»Impl(object):
    id_ = «transition.preCondition.id»

    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    override String transitionPreConditionPlan(State state, Transition transition) '''
from typing import Any
from engine import RunningPlan
from gen.domain.domain_condition import DomainCondition
from impl.conditions.pre_condition_«transition.preCondition.id»_impl import PreCondition«transition.preCondition.id»Impl


class PreCondition«transition.preCondition.id»(DomainCondition):
    id_ = «transition.preCondition.id»

    def __init__(self, context: Any) -> None:
        super().__init__(context)
        self.impl = PreCondition«transition.preCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return self.impl.evaluate(rp)
'''

    override String transitionPreConditionPlanImpl(Transition transition) '''
from engine import RunningPlan, BasicPlan, DefaultUtilityFunction
from gen.domain.domain_condition import DomainCondition


class PreCondition«transition.preCondition.id»Impl(object):
    id_ = «transition.preCondition.id»

    def __init__(self, condition: DomainCondition) -> None:
        self.condition = condition

    def evaluate(self, running_plan: RunningPlan) -> bool:
        print("The PreCondition {} in Transition «transition.getName» is not implement yet!".format(id_));
        return False
'''

}
