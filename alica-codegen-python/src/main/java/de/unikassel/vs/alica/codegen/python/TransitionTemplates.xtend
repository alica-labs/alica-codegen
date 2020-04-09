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
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«transition.preCondition.id»_impl import Constraint«transition.preCondition.id»Impl


class Constraint«transition.preCondition.id»(BasicConstraint):
    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«transition.preCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        «var List<State> states = plan.states»
        «FOR state: states»
            «var List<Transition> outTransitions = state.outTransitions»
            «FOR outTransition: outTransitions»
                «IF outTransition.preCondition !== null»
                    «var List<Variable> variables = outTransition.preCondition.variables»
                    «IF (outTransition.preCondition !== null && outTransition.preCondition.pluginName == "DefaultPlugin" && variables.size > 0)»
                        self.impl.get_constraint(problem_descriptor, running_plan)
                    «ENDIF»
                «ENDIF»
            «ENDFOR»
        «ENDFOR»
'''

    override String constraintPlanTransitionPreConditionImpl(Transition transition) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«transition.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    override String transitionPreConditionPlan(State state, Transition transition) '''
from engine import RunningPlan
from domain_condition import DomainCondition
from impl.pre_condition_«transition.preCondition.id»_impl import PreCondition«transition.preCondition.id»Impl


class PreCondition«transition.preCondition.id»(DomainCondition):
    def __init__(self) -> None:
        super().__init__()
        self.impl = PreCondition«transition.preCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        result = True
        «var List<Transition> outTransitions = state.outTransitions»
        «FOR outTransition: outTransitions»
            «IF (outTransition.preCondition !== null && outTransition.preCondition.pluginName == "DefaultPlugin")»
                if not self.impl.evaluate(running_plan):
                    result = False
            «ENDIF»
        «ENDFOR»
        return result
'''

    override String transitionPreConditionPlanImpl(Transition transition) '''
from engine import RunningPlan
from engine import BasicPlan
from engine import DefaultUtilityFunction


class PreCondition«transition.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

}
