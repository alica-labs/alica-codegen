package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplates implements IDomainTemplates {

    override String domainBehaviour() '''
from engine import BasicBehaviour
from impl.domain_behaviour_impl import DomainBehaviourImpl


class DomainBehaviour(BasicBehaviour):
    def __init__(self, name: str) -> None:
        super().__init__(name)
        self.impl = DomainBehaviourImpl()
'''

    override String domainBehaviourImpl() '''
class DomainBehaviourImpl(object):
    def __init__(self) -> None:
        pass
'''

    override String domainCondition() '''
from engine import BasicCondition
from impl.domain_condition_impl import DomainConditionImpl


class DomainCondition(BasicCondition):
    def __init__(self) -> None:
        super().__init__()
        self.impl = DomainConditionImpl()
'''

    override String domainConditionImpl() '''
class DomainConditionImpl(object):
    def __init__(self) -> None:
        pass
'''

}
