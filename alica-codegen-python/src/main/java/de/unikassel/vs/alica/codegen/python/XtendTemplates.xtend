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
        from «beh.relativeDirectory».«StringUtils.lowerCase(beh.name)» import «beh.name»
    «ENDIF»
«ENDFOR»

class BehaviourCreator(object):
    def create_behaviour(behaviour_id):
        «FOR beh : behaviours»
        if behaviour_id == «beh.id»:
            return «beh.name»()
        «ENDFOR»

        raise ValueError("BehaviourCreator: Unknown behaviour requested: {}".format(behaviourId))
'''

    def String behaviour(Behaviour behaviour) '''
from domain_behaviour import DomainBehaviour
from impl.«StringUtils.lowerCase(behaviour.name)»_impl import «behaviour.name»Impl

class «behaviour.name»(DomainBehaviour):
    impl = None

    def __init__(self):
        super().__init__("«behaviour.name»")
        impl = «behaviour.name»Impl()

    def run(msg):
        impl.run(msg)

    def initialise_parameters():
        impl.initialiseParameters()
'''

    def String behaviourImpl(Behaviour behaviour) '''
class «behaviour.name»Impl:
    def __init__(self):
        pass

    def run(msg):
        raise NotImplementedError()

    def initialise_parameters():
        raise NotImplementedError()
'''

    def String utilityFunctionCreator(List<Plan> plans)'''
from engine import BasicUtilityFunction
«FOR p: plans»
    «IF (!p.relativeDirectory.isEmpty)»
        from «p.relativeDirectory».«StringUtils.lowerCase(p.name)»_«p.id» import «p.name»«p.id»
    «ENDIF»
«ENDFOR»

class UtilityFunctionCreator(object):
    def create_utility(utility_function_conf_id):
        «FOR p: plans»
        if utility_function_conf_id == «p.id»:
            return UtilityFunction«p.id»()
        «ENDFOR»

        raise ValueError("UtilityFunctionCreator: Unknown utility requested: {}".format(utility_function_conf_id))
'''

    def String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
from engine import BasicCondition

class ConditionCreator(object):
    def create_conditions(condition_conf_id):
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

        raise ValueError("ConditionCreator: Unknown condition id requested: {}".format(condition_conf_id))
'''

    def String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
from engine import BasicCondition

class ConstraintCreator(object):
    def create_constraint(constraint_conf_id):
        «FOR c: conditions»
            «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                if constraint_conf_id == «c.id»:
                    return Constraint«c.id»()
            «ENDIF»
        «ENDFOR»

        raise ValueError("ConstraintCreator: Unknown constraint requested: {}".format(constraint_conf_id))
'''

    def String behaviourCondition(Behaviour behaviour) '''
class «behaviour.name»«behaviour.id»(object):
    def __init__(self):
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
        impl = None

        def __init__(self):
            super().__init__()
            impl = PreCondition«behaviour.preCondition.id»Impl()

        def evaluate(running_plan):
            return impl.evaluate(running_plan)
    «ENDIF»
'''

def String preConditionBehaviourImpl(Behaviour behaviour) '''
class PreCondition«behaviour.preCondition.id»Impl(object):
    def __init__(self):
        pass

    def evaluate(running_plan):
        return True
'''

    def String runtimeConditionBehaviour(Behaviour behaviour) '''
from engine import RunningPlan
from domain_condition import DomainCondition
«IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
    from impl.runtime_condition_«behaviour.runtimeCondition.id»_impl import RunTimeCondition«behaviour.runtimeCondition.id»Impl
«ENDIF»

class RunTimeCondition«behaviour.runtimeCondition.id»(DomainCondition):
    «IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
        impl = None

        def __init__(self):
            super().__init__()
            impl = PostCondition«behaviour.postCondition.id»Impl()

        def evaluate(running_plan):
            return impl.evaluate(running_plan)
    «ENDIF»
'''

def String runtimeConditionBehaviourImpl(Behaviour behaviour) '''
class RunTimeCondition«behaviour.runtimeCondition.id»Impl:
    def __init__(self):
        pass

    def evaluate(running_plan):
        return True
'''

    def String postConditionBehaviour(Behaviour behaviour) '''
from engine import RunningPlan
from domain_condition import DomainCondition
«IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
    from impl.post_condition_«behaviour.postCondition.id»_impl import PostCondition«behaviour.postCondition.id»Impl
«ENDIF»

class PostCondition«behaviour.postCondition.id»(DomainCondition):
    «IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
        impl = None

        def __init__(self):
            super().__init__()
            impl = PostCondition«behaviour.postCondition.id»Impl()

        def evaluate(running_plan):
            return impl.evaluate(running_plan)
    «ENDIF»
'''

def String postConditionBehaviourImpl(Behaviour behaviour) '''
class PostCondition«behaviour.postCondition.id»Impl(object):
    def __init__(self):
        pass

    def evaluate(running_plan):
        return True
'''

    def String constraints(Behaviour behaviour) '''
class «behaviour.name»«behaviour.id»Constraints(object):
    def __init__(self):
        pass
'''

    def String constraintPreCondition(Behaviour behaviour) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«behaviour.preCondition.id»_impl import Constraint«behaviour.preCondition.id»Impl

class Constraint«behaviour.preCondition.id»(BasicConstraint):
    impl = None

    def __init__(self):
        super().__init__()
        impl = Constraint«behaviour.preCondition.id»Impl()

    def get_constraint(problem_descriptor, running_plan):
        «IF (behaviour.preCondition !== null && behaviour.preCondition.pluginName == "DefaultPlugin")»
            «IF (behaviour.preCondition.variables.size > 0) || (behaviour.preCondition.quantifiers.size > 0)»
                impl.get_constraint(problem_descriptor, running_plan)
            «ENDIF»
        «ENDIF»
'''

def String constraintPreConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor
from engine import RunningPlan

class Constraint«behaviour.preCondition.id»Impl(object):
    def __init__(self):
        pass

    def get_constraint(problem_descriptor, running_plan):
        pass
'''

    def String constraintRuntimeCondition(Behaviour behaviour) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«behaviour.runtimeCondition.id»_impl import Constraint«behaviour.runtimeCondition.id»Impl

class Constraint«behaviour.runtimeCondition.id»(BasicConstraint):
    impl = None

    def __init__(self):
        super().__init__()
        impl = Constraint«behaviour.runtimeCondition.id»Impl()

    def get_constraint(problem_descriptor, running_plan):
        «IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
            «IF (behaviour.runtimeCondition.variables.size > 0) || (behaviour.runtimeCondition.quantifiers.size > 0)»
                impl.get_constraint(problem_descriptor, running_plan)
            «ENDIF»
        «ENDIF»
'''

def String constraintRuntimeConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor
from engine import RunningPlan

class Constraint«behaviour.runtimeCondition.id»Impl(object):
    def __init__(self):
        pass

    def get_constraint(problem_descriptor, running_plan):
        pass
'''

    def String constraintPostCondition(Behaviour behaviour) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«behaviour.postCondition.id»_impl import Constraint«behaviour.postCondition.id»Impl

class Constraint«behaviour.postCondition.id»(BasicConstraint):
    impl = None

    def __init__(self):
        super().__init__()
        impl = Constraint«behaviour.postCondition.id»Impl()

    def get_constraint(problem_descriptor, running_plan):
        «IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
            «IF (behaviour.postCondition.variables.size > 0) || (behaviour.postCondition.quantifiers.size > 0)»
                impl.getConstraint(problem_descriptor, running_plan)
            «ENDIF»
        «ENDIF»
'''

def String constraintPostConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor
from engine import RunningPlan

class Constraint«behaviour.postCondition.id»Impl(object):
    def __init__(self):
        pass

    def get_constraint(problem_descriptor, running_plan):
        pass
'''

    def String constraints(Plan plan) '''
class «plan.name»«plan.id»Constraints(object):
    def __init__(self):
        pass
'''

    def String constraintPlanPreCondition(Plan plan) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«plan.preCondition.id»_impl import Constraint«plan.preCondition.id»Impl

class Constraint«plan.preCondition.id»(BasicConstraint):
    impl = None

    def __init__(self):
        super().__init__()
        impl = Constraint«plan.preCondition.id»Impl()

    def get_constraint(problem_descriptor, running_plan):
        «IF (plan.preCondition !== null && plan.preCondition.pluginName == "DefaultPlugin")»
            impl.get_constraint(problem_descriptor, running_plan)
        «ENDIF»
'''

def String constraintPlanPreConditionImpl(Plan plan) '''
from engine import ProblemDescriptor
from engine import RunningPlan

class Constraint«plan.preCondition.id»Impl(object):
    def __init__(self):
        pass

    def get_constraint(problem_descriptor, running_plan):
        pass
'''

    def String constraintPlanRuntimeCondition(Plan plan) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«plan.runtimeCondition.id» import Constraint«plan.runtimeCondition.id»

class Constraint«plan.runtimeCondition.id»(BasicConstraint):
    impl = None

    def __init__(self):
        super().__init__()
        impl = Constraint«plan.runtimeCondition.id»Impl()

    def get_constraint(problem_descriptor, running_plan):
        «IF (plan.runtimeCondition !== null && plan.runtimeCondition.pluginName == "DefaultPlugin")»
            impl.get_constraint(problem_descriptor, running_plan)
        «ENDIF»
'''

def String constraintPlanRuntimeConditionImpl(Plan plan) '''
from engine import ProblemDescriptor
from engine import RunningPlan

class Constraint«plan.runtimeCondition.id»Impl(object):
    def __init__(self):
        pass

    def get_constraint(problem_descriptor, running_plan):
        pass
'''

    def String constraintPlanTransitionPreCondition(Plan plan, Transition transition) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«transition.preCondition.id»_impl import Constraint«transition.preCondition.id»Impl

class Constraint«transition.preCondition.id»(BasicConstraint):
    impl = None

    def __init__(self):
        super().__init__()
        impl = Constraint«transition.preCondition.id»Impl()

    def get_constraint(problem_descriptor, running_plan):
        «var List<State> states = plan.states»
        «FOR state: states»
            «var List<Transition> outTransitions = state.outTransitions»
            «FOR outTransition: outTransitions»
                «IF outTransition.preCondition !== null»
                    «var List<Variable> variables = outTransition.preCondition.variables»
                    «IF (outTransition.preCondition !== null && outTransition.preCondition.pluginName == "DefaultPlugin" && variables.size > 0)»
                        impl.get_constraint(problem_descriptor, running_plan)
                    «ENDIF»
                «ENDIF»
            «ENDFOR»
        «ENDFOR»
'''

def String constraintPlanTransitionPreConditionImpl(Transition transition) '''
from engine import ProblemDescriptor
from engine import RunningPlan

class Constraint«transition.preCondition.id»Impl(object):
    def __init__(self):
        pass

    def get_constraint(problem_descriptor, running_plan):
        pass
'''

    def String domainBehaviour() '''
from engine import BasicBehaviour
from impl.domain_behaviour_impl import DomainBehaviourImpl

class DomainBehaviour(BasicBehaviour):
    impl = None

    def __init__(self, name):
        super().__init__(name)
        impl = DomainBehaviourImpl()
'''

    def String domainBehaviourImpl() '''
class DomainBehaviourImpl(object):
    def __init__(self):
        pass
'''

    def String domainCondition() '''
from engine import BasicCondition
from impl.domain_condition_impl import DomainConditionImpl

class DomainCondition(BasicCondition):
    impl = None

    def __init__(self):
        super().__init__()
        impl = DomainConditionImpl()
'''

    def String domainConditionImpl() '''
class DomainConditionImpl(object):
    def __init__(self):
        pass
'''

    def String plan(Plan plan) '''
from engine import BasicPlan
from engine import BasicUtilityFunction
from impl.«StringUtils.lowerCase(plan.name)»_«plan.id»_impl import «plan.name»«plan.id»Impl

class «plan.name»«plan.id»(BasicPlan):
    impl = None

    def __init__(self):
        super().__init__()
        impl = «plan.name»«plan.id»Impl()

    def get_utility_function(basic_plan):
        return impl.getUtilityFunction(plan)
'''

    def String utilityFunctionPlan(Plan plan) '''
from engine import BasicUtilityFunction
from engine import BasicPlan
from engine import UtilityFunction
from impl.utility_function_«plan.id»_impl import UtilityFunction«plan.id»Impl

class UtilityFunction«plan.id»(BasicUtilityFunction):
    impl = None

    def __init__(self):
        super().__init__()
        impl = UtilityFunction«plan.id»Impl()

    def get_utility_function(basic_plan):
        return impl.getUtilityFunction(plan)
'''

    def String utilityFunctionPlanImpl(Plan plan) '''
from engine import BasicPlan
from engine import UtilityFunction
from engine import DefaultUtilityFunction

class UtilityFunction«plan.id»Impl(object):
    def __init__(self):
        pass

    def get_utility_function(basic_plan):
        return DefaultUtilityFunction(plan)
'''

    def String preConditionPlan(Plan plan) '''
from engine import RunningPlan
from domain_condition import DomainCondition
from impl.pre_condition_«plan.preCondition.id»_impl import PreCondition«plan.preCondition.id»Impl

class PreCondition«plan.preCondition.id»(DomainCondition):
    impl = None

    def __init__(self):
        super().__init__()
        impl = PreCondition«plan.preCondition.id»Impl()

    def evaluate(running_plan):
        «IF (plan.preCondition !== null && plan.preCondition.pluginName == "DefaultPlugin")»
            return impl.evaluate(running_plan)
        «ELSE»
            return True
        «ENDIF»
'''

def String preConditionPlanImpl(Plan plan) '''
from engine import RunningPlan

class PreCondition«plan.preCondition.id»Impl(object):
    def __init__(self):
        pass

    def evaluate(running_plan):
        return True
'''

    def String runtimeConditionPlan(Plan plan) '''
from engine import RunningPlan
from domain_condition import DomainCondition
from impl.runtime_condition_«plan.runtimeCondition.id»_impl import RunTimeCondition«plan.runtimeCondition.id»Impl

class RunTimeCondition«plan.runtimeCondition.id»(DomainCondition):
    impl = None

    def __init__(self):
        super().__init__()
        impl = RunTimeCondition«plan.runtimeCondition.id»Impl()

    def evaluate(running_plan):
        «IF (plan.runtimeCondition !== null && plan.runtimeCondition.pluginName == "DefaultPlugin")»
            impl.evaluate(running_plan)
        «ELSE»
            return True
        «ENDIF»
'''

def String runtimeConditionPlanImpl(Plan plan) '''
from engine import RunningPlan

class RunTimeCondition«plan.runtimeCondition.id»Impl(object):
    def __init__(self):
        pass

    def evaluate(running_plan):
        return True
'''

    def String transitionPreConditionPlan(State state, Transition transition) '''
from engine import RunningPlan
from DomainCondition import DomainCondition
from impl.pre_condition_«transition.preCondition.id»_impl import PreCondition«transition.preCondition.id»Impl

class PreCondition«transition.preCondition.id»(DomainCondition):
    impl = None

    def __init__(self):
        super().__init__()
        impl = PreCondition«transition.preCondition.id»Impl()

    def evaluate(running_plan):
        result = True
        «var List<Transition> outTransitions = state.outTransitions»
        «FOR outTransition: outTransitions»
            «IF (outTransition.preCondition !== null && outTransition.preCondition.pluginName == "DefaultPlugin")»
                if not impl.evaluate(running_plan):
                    result = False
            «ENDIF»
        «ENDFOR»
        return result
'''

def String transitionPreConditionPlanImpl(Transition transition) '''
from engine import RunningPlan

class PreCondition«transition.preCondition.id»Impl(object):
    def __init__(self):
        pass

    def evaluate(running_plan):
        return True
'''

    def String planImpl(Plan plan) '''
from engine import BasicPlan
from engine import BasicUtilityFunction
from engine import DefaultUtilityFunction

class «plan.name»«plan.id»Impl(object):
    def get_utility_function(basic_plan):
        return DefaultUtilityFunction(plan)
'''
}
