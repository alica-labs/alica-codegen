package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.RuntimeCondition;
import java.util.List;
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition;
import de.unikassel.vs.alica.planDesigner.alicamodel.State;
import de.unikassel.vs.alica.planDesigner.alicamodel.Variable;
import org.apache.commons.lang3.StringUtils;


class XtendTemplates {

    def String behaviourCreator(List<Behaviour> behaviours)'''
from engine import BasicBehaviour
«FOR beh : behaviours»
    «IF (!beh.relativeDirectory.isEmpty)»
        from «beh.relativeDirectory».«StringUtils.lowerCase(beh.name)» import «StringUtils.capitalize(beh.name)»
    «ELSE»
        from «StringUtils.lowerCase(beh.name)» import «StringUtils.capitalize(beh.name)»
    «ENDIF»
«ENDFOR»


class BehaviourCreator(object):
    def create_behaviour(self, behaviour_id: int) -> BasicBehaviour:
        «FOR beh : behaviours»
        if behaviour_id == «beh.id»:
            return «StringUtils.capitalize(beh.name)»()
        «ENDFOR»
        print("BehaviourCreator: Unknown behaviour requested: {}".format(behaviour_id))
'''

    def String behaviour(Behaviour behaviour) '''
from typing import Any
from domain_behaviour import DomainBehaviour
from impl.«StringUtils.lowerCase(behaviour.name)»_impl import «StringUtils.capitalize(behaviour.name)»Impl


class «StringUtils.capitalize(behaviour.name)»(DomainBehaviour):
    def __init__(self) -> None:
        super().__init__("«StringUtils.capitalize(behaviour.name)»")
        self.impl = «StringUtils.capitalize(behaviour.name)»Impl()

    def run(self, msg: Any) -> None:
        self.impl.run(msg)

    def initialise_parameters(self) -> None:
        self.impl.initialise_parameters()
'''

    def String behaviourImpl(Behaviour behaviour) '''
from typing import Any


class «StringUtils.capitalize(behaviour.name)»Impl:
    def __init__(self) -> None:
        pass

    def run(self, msg: Any) -> None:
        pass

    def initialise_parameters(self) -> None:
        pass
'''

    def String utilityFunctionCreator(List<Plan> plans)'''
from engine import BasicUtilityFunction
«FOR p: plans»
    from utility_function_«p.id» import UtilityFunction«p.id»
«ENDFOR»


class UtilityFunctionCreator(object):
    def create_utility(self, utility_function_conf_id: int) -> BasicUtilityFunction:
        «FOR p: plans»
        if utility_function_conf_id == «p.id»:
            return UtilityFunction«p.id»()
        «ENDFOR»
        print("UtilityFunctionCreator: Unknown utility requested: {}".format(utility_function_conf_id))
'''

    def String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
from engine import BasicCondition
«FOR con: conditions»
    from pre_condition_«con.id» import PreCondition«con.id»
«ENDFOR»


class ConditionCreator(object):
    def create_conditions(self, condition_conf_id: int) -> BasicCondition:
        «FOR con: conditions»
        if condition_conf_id == «con.id»:
            «IF (con instanceof PreCondition)»
            return PreCondition«con.id»()
            «ENDIF»
            «IF (con instanceof PostCondition)»
            return PostCondition«con.id»()
            «ENDIF»
            «IF (con instanceof RuntimeCondition)»
            return RunTimeCondition«con.id»()
            «ENDIF»
        «ENDFOR»
        print("ConditionCreator: Unknown condition id requested: {}".format(condition_conf_id))
'''

    def String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
from engine import BasicConstraint


class ConstraintCreator(object):
    def create_constraint(self, constraint_conf_id: int) -> BasicConstraint:
        «FOR c: conditions»
            «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                if constraint_conf_id == «c.id»:
                    return Constraint«c.id»()
            «ENDIF»
        «ENDFOR»
        print("ConstraintCreator: Unknown constraint requested: {}".format(constraint_conf_id))
'''

    def String behaviourCondition(Behaviour behaviour) '''
class «StringUtils.capitalize(behaviour.name)»«behaviour.id»(object):
    def __init__(self) -> None:
        pass
'''

    def String preConditionBehaviour(Behaviour behaviour) '''
from engine import RunningPlan
from domain_condition import DomainCondition
«IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
    from impl.pre_condition_«behaviour.preCondition.id»_impl import PreCondition«behaviour.preCondition.id»Impl
«ENDIF»


class PreCondition«behaviour.preCondition.id»(DomainCondition):
    «IF (behaviour.preCondition !== null && behaviour.preCondition.pluginName == "DefaultPlugin")»
        def __init__(self) -> None:
            super().__init__()
            self.impl = PreCondition«behaviour.preCondition.id»Impl()

        def evaluate(self, running_plan: RunningPlan) -> bool:
            return self.impl.evaluate(running_plan)
    «ENDIF»
'''

def String preConditionBehaviourImpl(Behaviour behaviour) '''
from engine import RunningPlan


class PreCondition«behaviour.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    def String runtimeConditionBehaviour(Behaviour behaviour) '''
from engine import RunningPlan
from domain_condition import DomainCondition
«IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
    from impl.runtime_condition_«behaviour.runtimeCondition.id»_impl import RunTimeCondition«behaviour.runtimeCondition.id»Impl
«ENDIF»


class RunTimeCondition«behaviour.runtimeCondition.id»(DomainCondition):
    «IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
        def __init__(self) -> None:
            super().__init__()
            self.impl = PostCondition«behaviour.postCondition.id»Impl()

        def evaluate(self, running_plan: RunningPlan) -> bool:
            return self.impl.evaluate(running_plan)
    «ENDIF»
'''

def String runtimeConditionBehaviourImpl(Behaviour behaviour) '''
from engine import RunningPlan


class RunTimeCondition«behaviour.runtimeCondition.id»Impl:
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    def String postConditionBehaviour(Behaviour behaviour) '''
from engine import RunningPlan
from domain_condition import DomainCondition
«IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
    from impl.post_condition_«behaviour.postCondition.id»_impl import PostCondition«behaviour.postCondition.id»Impl
«ENDIF»


class PostCondition«behaviour.postCondition.id»(DomainCondition):
    «IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
        def __init__(self) -> None:
            super().__init__()
            self.impl = PostCondition«behaviour.postCondition.id»Impl()

        def evaluate(self, running_plan: RunningPlan) -> bool:
            return self.impl.evaluate(running_plan)
    «ENDIF»
'''

def String postConditionBehaviourImpl(Behaviour behaviour) '''
from engine import RunningPlan


class PostCondition«behaviour.postCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    def String constraints(Behaviour behaviour) '''
class «StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints(object):
    def __init__(self) -> None:
        pass
'''

    def String constraintPreCondition(Behaviour behaviour) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«behaviour.preCondition.id»_impl import Constraint«behaviour.preCondition.id»Impl


class Constraint«behaviour.preCondition.id»(BasicConstraint):
    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«behaviour.preCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        «IF (behaviour.preCondition !== null && behaviour.preCondition.pluginName == "DefaultPlugin")»
            «IF (behaviour.preCondition.variables.size > 0) || (behaviour.preCondition.quantifiers.size > 0)»
                self.impl.get_constraint(problem_descriptor, running_plan)
            «ENDIF»
        «ENDIF»
'''

def String constraintPreConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«behaviour.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    def String constraintRuntimeCondition(Behaviour behaviour) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«behaviour.runtimeCondition.id»_impl import Constraint«behaviour.runtimeCondition.id»Impl


class Constraint«behaviour.runtimeCondition.id»(BasicConstraint):
    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«behaviour.runtimeCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        «IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
            «IF (behaviour.runtimeCondition.variables.size > 0) || (behaviour.runtimeCondition.quantifiers.size > 0)»
                self.impl.get_constraint(problem_descriptor, running_plan)
            «ENDIF»
        «ENDIF»
'''

def String constraintRuntimeConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«behaviour.runtimeCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    def String constraintPostCondition(Behaviour behaviour) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«behaviour.postCondition.id»_impl import Constraint«behaviour.postCondition.id»Impl


class Constraint«behaviour.postCondition.id»(BasicConstraint):
    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«behaviour.postCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        «IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
            «IF (behaviour.postCondition.variables.size > 0) || (behaviour.postCondition.quantifiers.size > 0)»
                self.impl.getConstraint(problem_descriptor, running_plan)
            «ENDIF»
        «ENDIF»
'''

def String constraintPostConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«behaviour.postCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    def String constraints(Plan plan) '''
class «StringUtils.capitalize(plan.name)»«plan.id»Constraints(object):
    def __init__(self) -> None:
        pass
'''

    def String constraintPlanPreCondition(Plan plan) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«plan.preCondition.id»_impl import Constraint«plan.preCondition.id»Impl


class Constraint«plan.preCondition.id»(BasicConstraint):
    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«plan.preCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        «IF (plan.preCondition !== null && plan.preCondition.pluginName == "DefaultPlugin")»
            self.impl.get_constraint(problem_descriptor, running_plan)
        «ENDIF»
'''

def String constraintPlanPreConditionImpl(Plan plan) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«plan.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    def String constraintPlanRuntimeCondition(Plan plan) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«plan.runtimeCondition.id» import Constraint«plan.runtimeCondition.id»


class Constraint«plan.runtimeCondition.id»(BasicConstraint):
    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«plan.runtimeCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        «IF (plan.runtimeCondition !== null && plan.runtimeCondition.pluginName == "DefaultPlugin")»
            self.impl.get_constraint(problem_descriptor, running_plan)
        «ENDIF»
'''

def String constraintPlanRuntimeConditionImpl(Plan plan) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«plan.runtimeCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    def String constraintPlanTransitionPreCondition(Plan plan, Transition transition) '''
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

def String constraintPlanTransitionPreConditionImpl(Transition transition) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«transition.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    def String domainBehaviour() '''
from engine import BasicBehaviour
from impl.domain_behaviour_impl import DomainBehaviourImpl


class DomainBehaviour(BasicBehaviour):
    def __init__(self, name: str) -> None:
        super().__init__(name)
        self.impl = DomainBehaviourImpl()
'''

    def String domainBehaviourImpl() '''
class DomainBehaviourImpl(object):
    def __init__(self) -> None:
        pass
'''

    def String domainCondition() '''
from engine import BasicCondition
from impl.domain_condition_impl import DomainConditionImpl


class DomainCondition(BasicCondition):
    def __init__(self) -> None:
        super().__init__()
        self.impl = DomainConditionImpl()
'''

    def String domainConditionImpl() '''
class DomainConditionImpl(object):
    def __init__(self) -> None:
        pass
'''

    def String plan(Plan plan) '''
from engine import BasicPlan
from engine import BasicUtilityFunction
from impl.«StringUtils.lowerCase(plan.name)»_«plan.id»_impl import «StringUtils.capitalize(plan.name)»«plan.id»Impl


class «StringUtils.capitalize(plan.name)»«plan.id»(BasicPlan):
    def __init__(self) -> None:
        super().__init__()
        self.impl = «StringUtils.capitalize(plan.name)»«plan.id»Impl()

    def get_utility_function(self, basic_plan: BasicPlan) -> BasicUtilityFunction:
        return self.impl.get_utility_function(basic_plan)
'''

    def String utilityFunctionPlan(Plan plan) '''
from engine import BasicPlan
from engine import BasicUtilityFunction
from impl.utility_function_«plan.id»_impl import UtilityFunction«plan.id»Impl


class UtilityFunction«plan.id»(BasicUtilityFunction):
    def __init__(self) -> None:
        super().__init__()
        self.impl = UtilityFunction«plan.id»Impl()

    def get_utility_function(self, basic_plan: BasicPlan) -> BasicUtilityFunction:
        return self.impl.get_utility_function(basic_plan)
'''

    def String utilityFunctionPlanImpl(Plan plan) '''
from engine import BasicPlan
from engine import DefaultUtilityFunction


class UtilityFunction«plan.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_utility_function(self, basic_plan: BasicPlan) -> DefaultUtilityFunction:
        return DefaultUtilityFunction(basic_plan)
'''

    def String preConditionPlan(Plan plan) '''
from engine import RunningPlan
from domain_condition import DomainCondition
from impl.pre_condition_«plan.preCondition.id»_impl import PreCondition«plan.preCondition.id»Impl


class PreCondition«plan.preCondition.id»(DomainCondition):
    def __init__(self) -> None:
        super().__init__()
        self.impl = PreCondition«plan.preCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        «IF (plan.preCondition !== null && plan.preCondition.pluginName == "DefaultPlugin")»
            return self.impl.evaluate(running_plan)
        «ELSE»
            return True
        «ENDIF»
'''

def String preConditionPlanImpl(Plan plan) '''
from engine import RunningPlan


class PreCondition«plan.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    def String runtimeConditionPlan(Plan plan) '''
from engine import RunningPlan
from domain_condition import DomainCondition
from impl.runtime_condition_«plan.runtimeCondition.id»_impl import RunTimeCondition«plan.runtimeCondition.id»Impl


class RunTimeCondition«plan.runtimeCondition.id»(DomainCondition):
    def __init__(self) -> None:
        super().__init__()
        self.impl = RunTimeCondition«plan.runtimeCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        «IF (plan.runtimeCondition !== null && plan.runtimeCondition.pluginName == "DefaultPlugin")»
            self.impl.evaluate(running_plan)
        «ELSE»
            return True
        «ENDIF»
'''

def String runtimeConditionPlanImpl(Plan plan) '''
from engine import RunningPlan


class RunTimeCondition«plan.runtimeCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    def String transitionPreConditionPlan(State state, Transition transition) '''
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

def String transitionPreConditionPlanImpl(Transition transition) '''
from engine import RunningPlan
from engine import BasicPlan
from engine import DefaultUtilityFunction


class PreCondition«transition.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    def String planImpl(Plan plan) '''
from engine import BasicPlan
from engine import DefaultUtilityFunction


class «StringUtils.capitalize(plan.name)»«plan.id»Impl(object):
    def get_utility_function(self, basic_plan: BasicPlan) -> DefaultUtilityFunction:
        return DefaultUtilityFunction(basic_plan)
'''
}
