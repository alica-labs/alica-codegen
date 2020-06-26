package de.unikassel.vs.alica.codegen.cpp.templates;

import de.unikassel.vs.alica.codegen.templates.IDomainTemplates;


class DomainTemplatesSource implements IDomainTemplates {

    override String domainBehaviour() '''
#include "DomainBehaviour.h"
#include "DomainBehaviourImpl.h"
#include <engine/BasicBehaviour.h>

namespace alica {
    DomainBehaviour::DomainBehaviour(std::string name, long id, void* context): BasicBehaviour(name) {
        this -> id = id;
        this -> context = context;
        this -> impl = new DomainBehaviourImpl(this);
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
#include <engine/BasicCondition.h>

namespace alica {
    DomainCondition::DomainCondition(void* context): BasicCondition() {

    }

    DomainCondition::~DomainCondition() {

    }
}
'''

    override String domainConditionImpl() '''
#include "DomainConditionImpl.h"
#include <engine/RunningPlan.h>
#include <iostream>
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
