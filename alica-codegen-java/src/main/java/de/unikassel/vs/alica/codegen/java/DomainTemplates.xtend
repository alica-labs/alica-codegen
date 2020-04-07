package de.unikassel.vs.alica.codegen.java;


class DomainTemplates {

    def String domainBehaviour() '''
package de.uniks.vs.alica.code.gen.domain;

import de.uniks.vs.alica.code.impl.domain.DomainBehaviourImpl;
import de.uniks.vs.jalica.engine.BasicBehaviour;

public abstract class DomainBehaviour extends BasicBehaviour {
    protected DomainBehaviourImpl impl;
    private long id;
    private Object context;

    public DomainBehaviour(String name, long id, Object context) {
        super(name);
        this.id = id;
        this.context = context;
    }

    public Object getContext() {
        return context;
    }

    public long getOwnId() {
        return this.id;
    }
}
'''

    def String domainBehaviourImpl() '''
package de.uniks.vs.alica.code.impl.domain;

import de.uniks.vs.alica.code.gen.domain.DomainBehaviour;

public class DomainBehaviourImpl {
    protected DomainBehaviour domain;

    public DomainBehaviourImpl(DomainBehaviour domain) {
        this.domain = domain;
    }

    public void run(Object msg) {

    }

    public void initialiseParameters() {

    }
}
'''

    def String domainCondition() '''
package de.uniks.vs.alica.code.gen.domain;

import de.uniks.vs.alica.code.impl.domain.DomainConditionImpl;
import de.uniks.vs.jalica.engine.BasicCondition;

public abstract class DomainCondition extends BasicCondition {
    protected DomainConditionImpl impl;

    public DomainCondition(Object context) {
        super();
    }
}
'''

    def String domainConditionImpl() '''
package de.uniks.vs.alica.code.impl.domain;

import de.uniks.vs.jalica.engine.RunningPlan;

public class DomainConditionImpl {
    public DomainConditionImpl() {}

    public boolean evaluate(RunningPlan rp) {
        System.out.println("DC-Impl: Missing link");
        return false;
    }
}
'''

}
