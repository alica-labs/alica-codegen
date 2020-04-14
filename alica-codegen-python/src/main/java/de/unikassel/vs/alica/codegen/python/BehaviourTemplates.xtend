package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.IBehaviourTemplates;


class BehaviourTemplates implements IBehaviourTemplates {

    override String behaviour(Behaviour behaviour) '''
from typing import Any
from gen.domain.domain_behaviour import DomainBehaviour
from impl.behaviours.«StringUtils.lowerCase(behaviour.name)»_impl import «StringUtils.capitalize(behaviour.name)»Impl


class «StringUtils.capitalize(behaviour.name)»(DomainBehaviour):
    def __init__(self, context: Any) -> None:
        super().__init__("«StringUtils.capitalize(behaviour.name)»", «behaviour.id», context)
        self.impl = «StringUtils.capitalize(behaviour.name)»Impl(self)

    def run(self) -> None:
        pass

    def run(self, msg: Any) -> None:
        self.impl.run(msg)

    def initialise_parameters(self) -> None:
        self.impl.initialise_parameters()
'''

    override String behaviourImpl(Behaviour behaviour) '''
from typing import Any
from gen.domain.domain_behaviour import DomainBehaviour
from impl.domain.domain_behaviour_impl import DomainBehaviourImpl


class «StringUtils.capitalize(behaviour.name)»Impl(DomainBehaviourImpl):
    def __init__(self, domain: DomainBehaviour) -> None:
        super().__init__(domain);

    def run(self, msg: Any) -> None:
        print("Behaviour «StringUtils.capitalize(behaviour.name)»({}): started".format(self.domain.getOwnId()));

    def initialise_parameters(self) -> None:
        pass
'''

    override String behaviourCondition(Behaviour behaviour) '''
class «StringUtils.capitalize(behaviour.name)»«behaviour.id»(object):
    id_ = «behaviour.id»

    def __init__(self) -> None:
        pass
'''

    override String preConditionBehaviour(Behaviour behaviour) '''
from typing import Any
from engine import RunningPlan
from gen.domain.domain_condition import DomainCondition
from impl.conditions.pre_condition_«behaviour.preCondition.id»_impl import PreCondition«behaviour.preCondition.id»Impl


class PreCondition«behaviour.preCondition.id»(DomainCondition):
    id_ = «behaviour.preCondition.id»

    def __init__(self, context: Any) -> None:
        super().__init__(context)
        self.impl = PreCondition«behaviour.preCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return self.impl.evaluate(running_plan)
'''

    override String preConditionBehaviourImpl(Behaviour behaviour) '''
from engine import RunningPlan


class PreCondition«behaviour.preCondition.id»Impl(object):
    id_ = «behaviour.preCondition.id»

    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        print("The PreCondition {} is not implement yet!".format(id_));
        return False
'''

    override String runtimeConditionBehaviour(Behaviour behaviour) '''
from typing import Any
from engine import RunningPlan
from gen.domain.domain_condition import DomainCondition
from impl.conditions.runtime_condition_«behaviour.runtimeCondition.id»_impl import RunTimeCondition«behaviour.runtimeCondition.id»Impl


class RunTimeCondition«behaviour.runtimeCondition.id»(DomainCondition):
    id_ = «behaviour.runtimeCondition.id»

    def __init__(self, context: Any) -> None:
        super().__init__(context)
        self.impl = PostCondition«behaviour.postCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return self.impl.evaluate(running_plan)
'''

    override String runtimeConditionBehaviourImpl(Behaviour behaviour) '''
from engine import RunningPlan


class RunTimeCondition«behaviour.runtimeCondition.id»Impl:
    id_ = «behaviour.runtimeCondition.id»

    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    override String postConditionBehaviour(Behaviour behaviour) '''
from typing import Any
from engine import RunningPlan
from gen.domain.domain_condition import DomainCondition
from impl.conditions.post_condition_«behaviour.postCondition.id»_impl import PostCondition«behaviour.postCondition.id»Impl


class PostCondition«behaviour.postCondition.id»(DomainCondition):
    id_ = «behaviour.postCondition.id»

    def __init__(self, context: Any) -> None:
        super().__init__(context)
        self.impl = PostCondition«behaviour.postCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return self.impl.evaluate(running_plan)
'''

    override String postConditionBehaviourImpl(Behaviour behaviour) '''
from engine import RunningPlan


class PostCondition«behaviour.postCondition.id»Impl(object):
    id_ = «behaviour.postCondition.id»

    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    override String constraints(Behaviour behaviour) '''
class «StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints(object):
    id_ = «behaviour.id»

    def __init__(self) -> None:
        pass
'''

    override String constraintPreCondition(Behaviour behaviour) '''
from engine import BasicConstraint, ProblemDescriptor, RunningPlan
from impl.constraints.constraint_«behaviour.preCondition.id»_impl import Constraint«behaviour.preCondition.id»Impl


class Constraint«behaviour.preCondition.id»(BasicConstraint):
    id_ = «behaviour.preCondition.id»

    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«behaviour.preCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        self.impl.get_constraint(problem_descriptor, running_plan)
'''

    override String constraintPreConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor, RunningPlan


class Constraint«behaviour.preCondition.id»Impl(object):
    id_ = «behaviour.preCondition.id»

    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    override String constraintRuntimeCondition(Behaviour behaviour) '''
from engine import BasicConstraint, ProblemDescriptor, RunningPlan
from impl.constraints.constraint_«behaviour.runtimeCondition.id»_impl import Constraint«behaviour.runtimeCondition.id»Impl


class Constraint«behaviour.runtimeCondition.id»(BasicConstraint):
    id_ = «behaviour.runtimeCondition.id»

    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«behaviour.runtimeCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        self.impl.get_constraint(problem_descriptor, running_plan)
'''

    override String constraintRuntimeConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor, RunningPlan


class Constraint«behaviour.runtimeCondition.id»Impl(object):
    id_ = «behaviour.runtimeCondition.id»

    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    override String constraintPostCondition(Behaviour behaviour) '''
from engine import BasicConstraint, ProblemDescriptor, RunningPlan
from impl.constraints.constraint_«behaviour.postCondition.id»_impl import Constraint«behaviour.postCondition.id»Impl


class Constraint«behaviour.postCondition.id»(BasicConstraint):
    id_ = «behaviour.postCondition.id»

    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«behaviour.postCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        self.impl.getConstraint(problem_descriptor, running_plan)
'''

    override String constraintPostConditionImpl(Behaviour behaviour) '''
from engine import ProblemDescriptor, RunningPlan


class Constraint«behaviour.postCondition.id»Impl(object):
    id_ = «behaviour.postCondition.id»

    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

}
