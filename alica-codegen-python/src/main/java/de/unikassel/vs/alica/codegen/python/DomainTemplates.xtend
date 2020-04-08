package de.unikassel.vs.alica.codegen.python;


class XtendTemplates {

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

}
