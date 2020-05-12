package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplatesSource implements IDomainTemplates {

    override String domainBehaviour() '''
#include "DomainBehaviour.h"
#include "DomainBehaviourImpl.h"
#include "engine/BasicBehaviour.h"

namespace alica {
    DomainBehaviour::DomainBehaviour(std::string name, long id, void* context): BasicBehaviour(name) {
        this.id = id;
        this.context = context;
        this.impl = std::make_shared<DomainBehaviourImpl>(this);
    }

    DomainBehaviour::~DomainBehaviour() {

    }

    void* DomainBehaviour::getContext() {
        return this.context;
    }

    long DomainBehaviour::getOwnId() {
        return this.id;
    }
}
'''

    override String domainBehaviourImpl() '''
namespace alica {
    DomainBehaviourImpl::DomainBehaviourImpl(std::shared_ptr<DomainBehaviour> domain) {
        this.domain = domain;
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
namespace alica {
    DomainConditionImpl::DomainConditionImpl() {

    }

    boolean DomainConditionImpl::evaluate(std::shared_ptr<RunningPlan> rp) {
        std::cerr << "DC-Impl: Missing link" << std::endl;
        return false;
    }
}
'''

}
