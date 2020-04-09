package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.IBehaviourTemplates;


class BehaviourTemplates implements IBehaviourTemplates {

    override String behaviour(Behaviour behaviour) '''
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

    override String behaviourImpl(Behaviour behaviour) '''
from typing import Any


class «StringUtils.capitalize(behaviour.name)»Impl:
    def __init__(self) -> None:
        pass

    def run(self, msg: Any) -> None:
        pass

    def initialise_parameters(self) -> None:
        pass
'''

    override String behaviourCondition(Behaviour behaviour) '''
class «StringUtils.capitalize(behaviour.name)»«behaviour.id»(object):
    def __init__(self) -> None:
        pass
'''

    override String preConditionBehaviour(Behaviour behaviour) '''
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

    override String preConditionBehaviourImpl(Behaviour behaviour) '''
from engine import RunningPlan


class PreCondition«behaviour.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    override String runtimeConditionBehaviour(Behaviour behaviour) '''
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

    override String runtimeConditionBehaviourImpl(Behaviour behaviour) '''
from engine import RunningPlan


class RunTimeCondition«behaviour.runtimeCondition.id»Impl:
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    override String postConditionBehaviour(Behaviour behaviour) '''
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

    override String postConditionBehaviourImpl(Behaviour behaviour) '''
from engine import RunningPlan


class PostCondition«behaviour.postCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    override String constraints(Behaviour behaviour) '''
class «StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints(object):
    def __init__(self) -> None:
        pass
'''

    override String constraintPreCondition(Behaviour behaviour) '''
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

    override String constraintPreConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«behaviour.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    override String constraintRuntimeCondition(Behaviour behaviour) '''
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

    override String constraintRuntimeConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«behaviour.runtimeCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    override String constraintPostCondition(Behaviour behaviour) '''
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

    override String constraintPostConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«behaviour.postCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

}
