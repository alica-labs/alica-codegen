package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplatesSource implements IDomainTemplates {

    override String domainBehaviour() '''
#include "domain/DomainBehaviour.h"
#include "domain/DomainBehaviourImpl.h"
#include <string>

namespace alica {
    DomainBehaviour::DomainBehaviour(std::string name, long id, void* context): BasicBehaviour(name) {
        this -> id = id;
        this -> context = context;
        this -> impl = std::make_shared<DomainBehaviourImpl>(std::shared_ptr<DomainBehaviour>(this));
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
#include "domain/DomainBehaviour.h"
#include "domain/DomainBehaviourImpl.h"

namespace alica {
    DomainBehaviourImpl::DomainBehaviourImpl(std::shared_ptr<DomainBehaviour> domain) {
        this -> domain = domain;
    }

    void DomainBehaviourImpl::run(void* msg) {

    }

    void DomainBehaviourImpl::initialiseParameters() {

    }
}
'''

    override String domainCondition() '''
#include "domain/DomainCondition.h"

namespace alica {
    DomainCondition::DomainCondition(void* context): BasicCondition() {

    }

    DomainCondition::~DomainCondition() {

    }
}
'''

    override String domainConditionImpl() '''
#include "domain/DomainBehaviour.h"
#include "domain/DomainConditionImpl.h"
#include <engine/RunningPlan.h>
#include <iostream>

namespace alica {
    DomainConditionImpl::DomainConditionImpl() {

    }

    bool DomainConditionImpl::evaluate(std::shared_ptr<RunningPlan> rp) {
        std::cerr << "DC-Impl: Missing link" << std::endl;
        return false;
    }
}
'''

}
