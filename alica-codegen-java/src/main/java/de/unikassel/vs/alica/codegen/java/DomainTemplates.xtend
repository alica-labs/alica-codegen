package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.RuntimeCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition;
import de.unikassel.vs.alica.planDesigner.alicamodel.State;
import de.unikassel.vs.alica.planDesigner.alicamodel.Variable;
import java.util.List;
import org.apache.commons.lang3.StringUtils;


class DomainTemplates {

    def String domainBehaviour() '''
package de.uniks.vs.alica.code.gen.domain;

import de.uniks.vs.alica.code.impl.domain.DomainBehaviourImpl;
import de.uniks.vs.jalica.engine.BasicBehaviour;

public abstract class DomainBehaviour extends BasicBehaviour {
    protected DomainBehaviourImpl impl;
    private Object context;

    public DomainBehaviour(String name, Object context) {
        super(name);
        this.context = context;
    }

    public Object getContext() {
        return context;
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

    public void run(Object msg) { }

    public void initialiseParameters() { }
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
