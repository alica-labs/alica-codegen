package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplatesSource implements IDomainTemplates {

    override String domainBehaviour() '''
#include "DomainBehaviour.h"

namespace alica {
    DomainBehaviour::DomainBehaviour(std::string name, long id, void* context): BasicBehaviour(name) {
        this -> id = id;
        this -> context = context;
        // this -> impl = new DomainBehaviourImpl(this);  // TODO: check how to fix this
    }

    DomainBehaviour::~DomainBehaviour() {

    }

    void* DomainBehaviour::getContext() {
        return this -> context;
    }

    long DomainBehaviour::getOwnId() {
        return this -> id;
    }
}
'''

    override String domainBehaviourImpl() '''
#include "DomainBehaviourImpl.h"

namespace alica {
    DomainBehaviourImpl::DomainBehaviourImpl(DomainBehaviour* domain) {
        this -> domain = domain;
    }

    void DomainBehaviourImpl::run(void* msg) {

    }

    void DomainBehaviourImpl::initialiseParameters() {

    }
}
'''

    override String domainCondition() '''
#include "DomainCondition.h"

namespace alica {
    DomainCondition::DomainCondition(void* context): BasicCondition() {

    }

    DomainCondition::~DomainCondition() {

    }
}
'''

    override String domainConditionImpl() '''
#include "DomainConditionImpl.h"

namespace alica {
    DomainConditionImpl::DomainConditionImpl() {

    }

    bool DomainConditionImpl::evaluate(RunningPlan* rp) {
        std::cerr << "DC-Impl: Missing link" << std::endl;
        return false;
    }
}
'''

}
