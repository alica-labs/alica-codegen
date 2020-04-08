package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import org.apache.commons.lang3.StringUtils;


class BehaviourTemplates {

    def String behaviour(Behaviour behaviour) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.uniks.vs.alica.code.gen.behaviours;
«ELSE»
    package de.uniks.vs.alica.code.gen.behaviours.«behaviour.relativeDirectory»;
«ENDIF»

import de.uniks.vs.alica.code.gen.domain.DomainBehaviour;
import de.uniks.vs.alica.code.impl.behaviours.«StringUtils.capitalize(behaviour.name)»Impl;

public class «StringUtils.capitalize(behaviour.name)» extends DomainBehaviour {
    public «StringUtils.capitalize(behaviour.name)»(Object context) {
        super("«behaviour.name»", «behaviour.id»L, context);
        this.impl = new «StringUtils.capitalize(behaviour.name)»Impl(this);
    }

    public void run(Object msg) {
        this.impl.run(msg);
    }

    public void initialiseParameters() {
        this.impl.initialiseParameters();
    }

    @Override
    public void run() {

    }
}
'''

    def String behaviourImpl(Behaviour behaviour) '''
package de.uniks.vs.alica.code.impl.behaviours;

import de.uniks.vs.alica.code.gen.domain.DomainBehaviour;
import de.uniks.vs.alica.code.impl.domain.DomainBehaviourImpl;

public class «StringUtils.capitalize(behaviour.name)»Impl extends DomainBehaviourImpl {
    public «StringUtils.capitalize(behaviour.name)»Impl(DomainBehaviour domain) {
        super(domain);
    }

    public void run(Object msg) {
        System.out.println("Behaviour «StringUtils.capitalize(behaviour.name)»(" + this.domain.getOwnId()+ "): started");
    }

    public void initialiseParameters() { }
}
'''

    def String behaviourCondition(Behaviour behaviour) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.uniks.vs.alica.code.gen.behaviours;
«ELSE»
    package de.uniks.vs.alica.code.gen.behaviours.«behaviour.relativeDirectory»;
«ENDIF»

public class «StringUtils.capitalize(behaviour.name)»«behaviour.id» {
    static long id = «behaviour.id»L;
}
'''

    def String preConditionBehaviour(Behaviour behaviour) '''
package de.uniks.vs.alica.code.gen.conditions;

import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.gen.domain.DomainCondition;
««««IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
    import de.uniks.vs.alica.code.impl.conditions.PreCondition«behaviour.preCondition.id»Impl;
««««ENDIF»

public class PreCondition«behaviour.preCondition.id» extends DomainCondition {
«««    «IF (behaviour.preCondition !== null && behaviour.preCondition.pluginName == "DefaultPlugin")»
        static long id = «behaviour.preCondition.id»L;

        private PreCondition«behaviour.preCondition.id»Impl impl;

        public PreCondition«behaviour.preCondition.id»(Object context) {
            super(context);
            impl = new PreCondition«behaviour.preCondition.id»Impl();
        }

        public boolean evaluate(RunningPlan rp) {
            return impl.evaluate(rp);
        }
«««    «ENDIF»
}
'''

def String preConditionBehaviourImpl(Behaviour behaviour) '''
package de.uniks.vs.alica.code.impl.conditions;

public class PreCondition«behaviour.preCondition.id»Impl {
    static long id = «behaviour.preCondition.id»L;

    public PreCondition«behaviour.preCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {
        System.out.println("The PreCondition " + id + " is not implement yet!");
        return false;
    }
}
'''

    def String runtimeConditionBehaviour(Behaviour behaviour) '''
package de.uniks.vs.alica.code.gen.conditions;

import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.gen.domain.DomainCondition;
««««IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
    import de.uniks.vs.alica.code.impl.conditions.RunTimeCondition«behaviour.runtimeCondition.id»Impl;
««««ENDIF»

public class RunTimeCondition«behaviour.runtimeCondition.id» extends DomainCondition {
«««    «IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
        static long id = «behaviour.runtimeCondition.id»L;

        private RunTimeCondition«behaviour.runtimeCondition.id»Impl impl;

        public RunTimeCondition«behaviour.runtimeCondition.id»(Object context) {
            super(context);
            impl = new PostCondition«behaviour.postCondition.id»Impl();
        }

        public boolean evaluate(RunningPlan rp) {
            return impl.evaluate(rp);
        }
«««    «ENDIF»
}
'''

def String runtimeConditionBehaviourImpl(Behaviour behaviour) '''
package de.uniks.vs.alica.code.impl.conditions;

public class RunTimeCondition«behaviour.runtimeCondition.id»Impl {
    static long id = «behaviour.runtimeCondition.id»L;

    public RunTimeCondition«behaviour.runtimeCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {
        return false;
    }
}
'''

    def String postConditionBehaviour(Behaviour behaviour) '''
package de.uniks.vs.alica.code.gen.conditions;

import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.gen.domain.DomainCondition;
««««IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
    import de.uniks.vs.alica.code.impl.conditions.PostCondition«behaviour.postCondition.id»Impl;
««««ENDIF»

public class PostCondition«behaviour.postCondition.id» extends DomainCondition {
«««    «IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
        static long id = «behaviour.postCondition.id»L;

        private PostCondition«behaviour.postCondition.id»Impl impl;

        public PostCondition«behaviour.postCondition.id»(Object context) {
            super(context);
            impl = new PostCondition«behaviour.postCondition.id»Impl();
        }

        public boolean evaluate(RunningPlan rp) {
            return impl.evaluate(rp);
        }
«««    «ENDIF»
}
'''

def String postConditionBehaviourImpl(Behaviour behaviour) '''
package de.uniks.vs.alica.code.impl.conditions;

public class PostCondition«behaviour.postCondition.id»Impl {
    static long id = «behaviour.postCondition.id»L;

    public PostCondition«behaviour.postCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {
        return false;
    }
}
'''

    def String constraints(Behaviour behaviour) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.uniks.vs.alica.code.gen.constraints;
«ELSE»
    package de.uniks.vs.alica.code.gen.«behaviour.relativeDirectory».constraints;
«ENDIF»

public class «StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints {
    static long id = «behaviour.id»L;
}
'''

    def String constraintPreCondition(Behaviour behaviour) '''
package de.uniks.vs.alica.code.gen.constraints;

import de.uniks.vs.jalica.engine.BasicConstraint;
import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.impl.constraints.Constraint«behaviour.preCondition.id»Impl;

public class Constraint«behaviour.preCondition.id» extends BasicConstraint {
    static long id = «behaviour.preCondition.id»L;

    private Constraint«behaviour.preCondition.id»Impl impl;

    public Constraint«behaviour.preCondition.id»() {
        super();
        impl = new Constraint«behaviour.preCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
«««        «IF (behaviour.preCondition !== null && behaviour.preCondition.pluginName == "DefaultPlugin")»
«««            «IF (behaviour.preCondition.variables.size > 0) || (behaviour.preCondition.quantifiers.size > 0)»
                impl.getConstraint(c, rp);
«««            «ENDIF»
«««        «ENDIF»
    }
}
'''

def String constraintPreConditionImpl(Behaviour behaviour) '''
package de.uniks.vs.alica.code.impl.constraints;

import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;

public class Constraint«behaviour.preCondition.id»Impl {
    static long id = «behaviour.preCondition.id»L;

    public Constraint«behaviour.preCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintRuntimeCondition(Behaviour behaviour) '''
package de.uniks.vs.alica.code.gen.constraints;

import de.uniks.vs.jalica.engine.BasicConstraint;
import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.impl.constraints.Constraint«behaviour.runtimeCondition.id»Impl;

public class Constraint«behaviour.runtimeCondition.id» extends BasicConstraint {
    static long id = «behaviour.runtimeCondition.id»L;

    private Constraint«behaviour.runtimeCondition.id»Impl impl;

    public Constraint«behaviour.runtimeCondition.id»() {
        super();
        impl = new Constraint«behaviour.runtimeCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
«««        «IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
«««            «IF (behaviour.runtimeCondition.variables.size > 0) || (behaviour.runtimeCondition.quantifiers.size > 0)»
                impl.getConstraint(c, rp);
«««            «ENDIF»
«««        «ENDIF»
    }
}
'''

def String constraintRuntimeConditionImpl(Behaviour behaviour) '''
package de.uniks.vs.alica.code.impl.constraints;

import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;

public class Constraint«behaviour.runtimeCondition.id»Impl {
    static long id = «behaviour.runtimeCondition.id»L;

    public Constraint«behaviour.runtimeCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintPostCondition(Behaviour behaviour) '''
package de.uniks.vs.alica.code.gen.constraints;

import de.uniks.vs.jalica.engine.BasicConstraint;
import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;
import de.uniks.vs.alica.code.impl.constraints.Constraint«behaviour.postCondition.id»Impl;

public class Constraint«behaviour.postCondition.id» extends BasicConstraint {
    static long id = «behaviour.postCondition.id»L;

    private Constraint«behaviour.postCondition.id»Impl impl;

    public Constraint«behaviour.postCondition.id»() {
        super();
        impl = new Constraint«behaviour.postCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
«««        «IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
«««            «IF (behaviour.postCondition.variables.size > 0) || (behaviour.postCondition.quantifiers.size > 0)»
                impl.getConstraint(c, rp);
«««            «ENDIF»
«««        «ENDIF»
    }
}
'''

def String constraintPostConditionImpl(Behaviour behaviour) '''
package de.uniks.vs.alica.code.impl.constraints;

import de.uniks.vs.jalica.engine.ProblemDescriptor;
import de.uniks.vs.jalica.engine.RunningPlan;

public class Constraint«behaviour.postCondition.id»Impl {
    static long id = «behaviour.postCondition.id»L;

    public Constraint«behaviour.postCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

}
