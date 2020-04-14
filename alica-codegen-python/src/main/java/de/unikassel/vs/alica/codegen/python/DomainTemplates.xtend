package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplates implements IDomainTemplates {

    override String domainBehaviour() '''
from typing import Any
from engine import BasicBehaviour


class DomainBehaviour(BasicBehaviour):
    def __init__(self, name: str, id_: int, context: Any) -> None:
        super().__init__(name)
        self.id_ = id_
        self.context = context
        from impl.domain.domain_behaviour_impl import DomainBehaviourImpl  # importing this at the top results in circular dependency
        self.impl = DomainBehaviourImpl(self)

    def get_context(self) -> Any:
        return self.context

    def get_own_id(self) -> int:
        return self.id_
'''

    override String domainBehaviourImpl() '''
from typing import Any
from gen.domain.domain_behaviour import DomainBehaviour


class DomainBehaviourImpl(object):
    def __init__(self, domain: DomainBehaviour) -> None:
        self.domain = domain

    def run(msg: Any) -> None:
        pass

    def initialise_parameters() -> None:
        pass
'''

    override String domainCondition() '''
from typing import Any
from engine import BasicCondition, RunningPlan
from impl.domain.domain_condition_impl import DomainConditionImpl


class DomainCondition(BasicCondition):
    def __init__(self, context: Any) -> None:
        super().__init__()
        self.impl = DomainConditionImpl()
'''

    override String domainConditionImpl() '''
class DomainConditionImpl(object):
    def __init__(self) -> None:
        pass

    def evaluate(rp: RunningPlan) -> bool:
        print("DC-Impl: Missing link");
        return False
'''

}
