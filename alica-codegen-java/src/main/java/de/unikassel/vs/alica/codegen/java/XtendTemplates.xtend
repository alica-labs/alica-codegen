package de.unikassel.vs.alica.codegen.java

import de.unikassel.vs.alica.codegen.IConstraintCodeGenerator
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition
import de.unikassel.vs.alica.planDesigner.alicamodel.RuntimeCondition
import java.util.List
import java.util.Map
import de.unikassel.vs.alica.planDesigner.alicamodel.Transition
import de.unikassel.vs.alica.planDesigner.alicamodel.EntryPoint
import de.unikassel.vs.alica.planDesigner.alicamodel.State
import de.unikassel.vs.alica.planDesigner.alicamodel.Variable
import org.apache.commons.lang3.StringUtils;


class XtendTemplates {

    def String behaviourCreator(List<Behaviour> behaviours)'''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicBehaviour;
«FOR beh : behaviours»
    «IF (!beh.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«beh.relativeDirectory».«StringUtils.capitalize(beh.name)»;
    «ENDIF»
«ENDFOR»

public class BehaviourCreator {
    public BasicBehaviour createBehaviour(long behaviourId) throws Exception {
        switch (String.valueOf(behaviourId)) {
            «FOR beh : behaviours»
                case "«beh.id»":
                    return new «StringUtils.capitalize(beh.name)»();
            «ENDFOR»
            default:
                System.err.println("BehaviourCreator: Unknown behaviour requested: " + behaviourId);
                throw new Exception();
        }
    }
}
'''

    def String behaviour(Behaviour behaviour) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«behaviour.relativeDirectory»;
«ENDIF»

import de.unikassel.vs.alica.codegen.out.impl.«StringUtils.capitalize(behaviour.name)»Impl;

public class «StringUtils.capitalize(behaviour.name)» extends DomainBehaviour {
    private «StringUtils.capitalize(behaviour.name)»Impl impl;

    public «StringUtils.capitalize(behaviour.name)»() {
        super("«behaviour.name»");
        impl = new «StringUtils.capitalize(behaviour.name)»Impl();
    }

    public void run(Object msg) {
        impl.run(msg);
    }

    public void initialiseParameters() {
        impl.initialiseParameters();
    }
}
'''

    def String behaviourImpl(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out.impl;

public class «StringUtils.capitalize(behaviour.name)»Impl {
    public «StringUtils.capitalize(behaviour.name)»Impl() {

    }

    public void run(Object msg) {
        throw new UnsupportedOperationException("Not implemented");
    }

    public void initialiseParameters() {
        throw new UnsupportedOperationException("Not implemented");
    }
}
'''

    def String utilityFunctionCreator(List<Plan> plans)'''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicUtilityFunction;
«FOR p: plans»
    «IF (!p.relativeDirectory.isEmpty)»
        import de.unikassel.vs.alica.codegen.out.«p.relativeDirectory».«StringUtils.capitalize(p.name)»«p.id»;
    «ENDIF»
«ENDFOR»

public class UtilityFunctionCreator {
    public BasicUtilityFunction createUtility(long utilityfunctionConfId) throws Exception {
        switch(String.valueOf(utilityfunctionConfId)) {
            «FOR p: plans»
                case "«p.id»":
                    return new UtilityFunction«p.id»();
            «ENDFOR»
            default:
                System.err.println("UtilityFunctionCreator: Unknown utility requested: " + utilityfunctionConfId);
                throw new Exception();
        }
    }
}
'''

    def String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicCondition;

public class ConditionCreator {
    public BasicCondition createConditions(long conditionConfId) throws Exception {
        switch (String.valueOf(conditionConfId)) {
            «FOR con: conditions»
                case "«con.id»":
                    «IF (con instanceof PreCondition)»
                        return new PreCondition«con.id»();
                    «ENDIF»
                    «IF (con instanceof PostCondition)»
                        return new PostCondition«con.id»();
                    «ENDIF»
                    «IF (con instanceof RuntimeCondition)»
                        return new RunTimeCondition«con.id»();
                    «ENDIF»
            «ENDFOR»
            default:
                System.err.println("ConditionCreator: Unknown condition id requested: " + conditionConfId);
                throw new Exception();
        }
    }
}
'''

    def String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicCondition;

public class ConstraintCreator {
    public BasicCondition createConstraint(long constraintConfId) throws Exception {
        switch (String.valueOf(constraintConfId)) {
            «FOR c: conditions»
                «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                    case "«c.id»":
                        return new Constraint«c.id»();
                «ENDIF»
            «ENDFOR»
            default:
                System.err.println("ConstraintCreator: Unknown constraint requested: " + constraintConfId);
                throw new Exception();
        }
    }
}
'''

    def String behaviourCondition(Behaviour behaviour, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«behaviour.relativeDirectory»;
«ENDIF»

public class «StringUtils.capitalize(behaviour.name)»«behaviour.id» {

}
'''

    def String preConditionBehaviour(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.RunningPlan;
import de.unikassel.vs.alica.codegen.out.DomainCondition;
«IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
    import de.unikassel.vs.alica.codegen.out.impl.PreCondition«behaviour.preCondition.id»Impl;
«ENDIF»

public class PreCondition«behaviour.preCondition.id» extends DomainCondition {
    «IF (behaviour.preCondition !== null && behaviour.preCondition.pluginName == "DefaultPlugin")»
        private PreCondition«behaviour.preCondition.id»Impl impl;

        public PreCondition«behaviour.preCondition.id»() {
            super();
            impl = new PreCondition«behaviour.preCondition.id»Impl();
        }

        public boolean evaluate(RunningPlan rp) {
            return impl.evaluate(rp);
        }
    «ENDIF»
}
'''

def String preConditionBehaviourImpl(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out.impl;

public class PreCondition«behaviour.preCondition.id»Impl {
    public PreCondition«behaviour.preCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {

    }
}
'''

    def String runtimeConditionBehaviour(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.RunningPlan;
import de.unikassel.vs.alica.codegen.out.DomainCondition;
«IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
    import de.unikassel.vs.alica.codegen.out.impl.RunTimeCondition«behaviour.runtimeCondition.id»Impl;
«ENDIF»

public class RunTimeCondition«behaviour.runtimeCondition.id» extends DomainCondition {
    «IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
        private RunTimeCondition«behaviour.runtimeCondition.id»Impl impl;

        public RunTimeCondition«behaviour.runtimeCondition.id»() {
            super();
            impl = new PostCondition«behaviour.postCondition.id»Impl();
        }

        public boolean evaluate(RunningPlan rp) {
            return impl.evaluate(rp);
        }
    «ENDIF»
}
'''

def String runtimeConditionBehaviourImpl(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out.impl;

public class RunTimeCondition«behaviour.runtimeCondition.id»Impl {
    public RunTimeCondition«behaviour.runtimeCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {

    }
}
'''

    def String postConditionBehaviour(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.RunningPlan;
import de.unikassel.vs.alica.codegen.out.DomainCondition;
«IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
    import de.unikassel.vs.alica.codegen.out.impl.PostCondition«behaviour.postCondition.id»Impl;
«ENDIF»

public class PostCondition«behaviour.postCondition.id» extends DomainCondition {
    «IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
        private PostCondition«behaviour.postCondition.id»Impl impl;

        public PostCondition«behaviour.postCondition.id»() {
            super();
            impl = new PostCondition«behaviour.postCondition.id»Impl();
        }

        public boolean evaluate(RunningPlan rp) {
            return impl.evaluate(rp);
        }
    «ENDIF»
}
'''

def String postConditionBehaviourImpl(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out.impl;

public class PostCondition«behaviour.postCondition.id»Impl {
    public PostCondition«behaviour.postCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {

    }
}
'''

    def String constraints(Behaviour behaviour, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (behaviour.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out.constraints;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«behaviour.relativeDirectory».constraints;
«ENDIF»

public class «StringUtils.capitalize(behaviour.name)»«behaviour.id»Constraints {

}
'''

    def String constraintPreCondition(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicConstraint;
import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«behaviour.preCondition.id» extends BasicConstraint {
    private Constraint«behaviour.preCondition.id»Impl impl;

    public Constraint«behaviour.preCondition.id»() {
        super();
        impl = new Constraint«behaviour.preCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
        «IF (behaviour.preCondition !== null && behaviour.preCondition.pluginName == "DefaultPlugin")»
            «IF (behaviour.preCondition.variables.size > 0) || (behaviour.preCondition.quantifiers.size > 0)»
                impl.getConstraint(c, rp);
            «ENDIF»
        «ENDIF»
    }
}
'''

def String constraintPreConditionImpl(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«behaviour.preCondition.id»Impl {
    public Constraint«behaviour.preCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintRuntimeCondition(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicConstraint;
import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«behaviour.runtimeCondition.id» extends BasicConstraint {
    private Constraint«behaviour.runtimeCondition.id»Impl impl;

    public Constraint«behaviour.runtimeCondition.id»() {
        super();
        impl = new Constraint«behaviour.runtimeCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
        «IF (behaviour.runtimeCondition !== null && behaviour.runtimeCondition.pluginName == "DefaultPlugin")»
            «IF (behaviour.runtimeCondition.variables.size > 0) || (behaviour.runtimeCondition.quantifiers.size > 0)»
                impl.getConstraint(c, rp);
            «ENDIF»
        «ENDIF»
    }
}
'''

def String constraintRuntimeConditionImpl(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«behaviour.runtimeCondition.id»Impl {
    public Constraint«behaviour.runtimeCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintPostCondition(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicConstraint;
import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«behaviour.postCondition.id» extends BasicConstraint {
    private Constraint«behaviour.postCondition.id»Impl impl;

    public Constraint«behaviour.postCondition.id»() {
        super();
        impl = new Constraint«behaviour.postCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
        «IF (behaviour.postCondition !== null && behaviour.postCondition.pluginName == "DefaultPlugin")»
            «IF (behaviour.postCondition.variables.size > 0) || (behaviour.postCondition.quantifiers.size > 0)»
                impl.getConstraint(c, rp);
            «ENDIF»
        «ENDIF»
    }
}
'''

def String constraintPostConditionImpl(Behaviour behaviour) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«behaviour.postCondition.id»Impl {
    public Constraint«behaviour.postCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraints(Plan plan, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (plan.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out.constraints;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«plan.relativeDirectory».constraints;
«ENDIF»

public class «StringUtils.capitalize(plan.name)»«plan.id»Constraints {

}
'''

    def String constraintPlanPreCondition(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicConstraint;
import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«plan.preCondition.id» extends BasicConstraint {
    private Constraint«plan.preCondition.id»Impl impl;

    public Constraint«plan.preCondition.id»() {
        super();
        impl = new Constraint«plan.preCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
        «IF (plan.preCondition !== null && plan.preCondition.pluginName == "DefaultPlugin")»
            impl.getConstraint(c, rp);
        «ENDIF»
    }
}
'''

def String constraintPlanPreConditionImpl(Plan plan) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«plan.preCondition.id»Impl {
    public Constraint«plan.preCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintPlanRuntimeCondition(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicConstraint;
import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«plan.runtimeCondition.id» extends BasicConstraint {
    private Constraint«plan.runtimeCondition.id»Impl impl;

    public Constraint«plan.runtimeCondition.id»() {
        super();
        impl = new Constraint«plan.runtimeCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
        «IF (plan.runtimeCondition !== null && plan.runtimeCondition.pluginName == "DefaultPlugin")»
            impl.getConstraint(c, rp);
        «ENDIF»
    }
}
'''

def String constraintPlanRuntimeConditionImpl(Plan plan) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«plan.runtimeCondition.id»Impl {
    public Constraint«plan.runtimeCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String constraintPlanTransitionPreCondition(Plan plan, Transition transition) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicConstraint;
import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«transition.preCondition.id» extends BasicConstraint {
    private Constraint«transition.preCondition.id»Impl impl;

    public Constraint«transition.preCondition.id»() {
        super();
        impl = new Constraint«transition.preCondition.id»Impl();
    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {
        «var List<State> states = plan.states»
        «FOR state: states»
            «var List<Transition> outTransitions = state.outTransitions»
            «FOR outTransition: outTransitions»
                «IF outTransition.preCondition != null»
                    «var List<Variable> variables = outTransition.preCondition.variables»
                    «IF (outTransition.preCondition !== null && outTransition.preCondition.pluginName == "DefaultPlugin" && variables.size > 0)»
                        impl.getConstraint(c, rp);
                    «ENDIF»
                «ENDIF»
            «ENDFOR»
        «ENDFOR»
    }
}
'''

def String constraintPlanTransitionPreConditionImpl(Transition transition) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.ProblemDescriptor;
import de.unikassel.vs.alica.engine.RunningPlan;

public class Constraint«transition.preCondition.id»Impl {
    public Constraint«transition.preCondition.id»Impl() {

    }

    public void getConstraint(ProblemDescriptor c, RunningPlan rp) {

    }
}
'''

    def String domainBehaviour() '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicBehaviour;
import de.unikassel.vs.alica.codegen.out.impl.DomainBehaviourImpl;

public class DomainBehaviour extends BasicBehaviour {
    private DomainBehaviourImpl impl;

    public DomainBehaviour(String name) {
        super(name);
        impl = new DomainBehaviourImpl();
    }
}
'''

    def String domainBehaviourImpl() '''
package de.unikassel.vs.alica.codegen.out.impl;

public class DomainBehaviourImpl {
    public DomainBehaviourImpl() {

    }
}
'''

    def String domainCondition() '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicCondition;
import de.unikassel.vs.alica.codegen.out.impl.DomainConditionImpl;

public class DomainCondition extends BasicCondition {
    private DomainConditionImpl impl;

    public DomainCondition() {
        super();
        impl = new DomainConditionImpl();
    }
}
'''

    def String domainConditionImpl() '''
package de.unikassel.vs.alica.codegen.out.impl;

public class DomainConditionImpl {
    public DomainConditionImpl() {

    }
}
'''

    def String plan(Plan plan, IConstraintCodeGenerator constraintCodeGenerator) '''
«IF (plan.relativeDirectory.isEmpty)»
    package de.unikassel.vs.alica.codegen.out;
«ELSE»
    package de.unikassel.vs.alica.codegen.out.«plan.relativeDirectory»;
«ENDIF»
import de.unikassel.vs.alica.engine.BasicPlan;
import de.unikassel.vs.alica.engine.BasicUtilityFunction;
import de.unikassel.vs.alica.codegen.out.impl.«StringUtils.capitalize(plan.name)»«plan.id»Impl;

public class «StringUtils.capitalize(plan.name)»«plan.id» extends BasicPlan {
    private «StringUtils.capitalize(plan.name)»«plan.id»Impl impl;

    public «StringUtils.capitalize(plan.name)»«plan.id»() {
        impl = new «StringUtils.capitalize(plan.name)»«plan.id»Impl();
    }

    public BasicUtilityFunction getUtilityFunction(BasicPlan plan) {
        return impl.getUtilityFunction(plan);
    }
}
'''

    def String utilityFunctionPlan(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.BasicUtilityFunction;
import de.unikassel.vs.alica.engine.BasicPlan;
import de.unikassel.vs.alica.engine.UtilityFunction;
import de.unikassel.vs.alica.codegen.out.impl.UtilityFunction«plan.id»Impl;

public class UtilityFunction«plan.id» extends BasicUtilityFunction {
    private UtilityFunction«plan.id»Impl impl;

    public UtilityFunction«plan.id»() {
        impl = new UtilityFunction«plan.id»Impl();
    }

    public UtilityFunction getUtilityFunction(BasicPlan plan) {
        return impl.getUtilityFunction(plan);
    }
}
'''

    def String utilityFunctionPlanImpl(Plan plan) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.BasicPlan;
import de.unikassel.vs.alica.engine.UtilityFunction;
import de.unikassel.vs.alica.engine.DefaultUtilityFunction;

public class UtilityFunction«plan.id»Impl {
    public UtilityFunction«plan.id»Impl() {

    }

    public UtilityFunction getUtilityFunction(BasicPlan plan) {
        return new DefaultUtilityFunction(plan);
    }
}
'''

    def String preConditionPlan(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.RunningPlan;
import de.unikassel.vs.alica.codegen.out.DomainCondition;

public class PreCondition«plan.preCondition.id» extends DomainCondition {
    private PreCondition«plan.preCondition.id»Impl impl;

    public PreCondition«plan.preCondition.id»() {
        super();
        impl = new PreCondition«plan.preCondition.id»Impl();
    }

    public boolean evaluate(RunningPlan rp) {
        «IF (plan.preCondition !== null && plan.preCondition.pluginName == "DefaultPlugin")»
            impl.evaluate(rp)
        «ENDIF»
    }
}
'''

def String preConditionPlanImpl(Plan plan) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.RunningPlan;

public class PreCondition«plan.preCondition.id»Impl {
    public PreCondition«plan.preCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {

    }
}
'''

    def String runtimeConditionPlan(Plan plan) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.RunningPlan;
import de.unikassel.vs.alica.codegen.out.DomainCondition;

public class RunTimeCondition«plan.runtimeCondition.id» extends DomainCondition {
    private RunTimeCondition«plan.runtimeCondition.id»Impl impl;

    public RunTimeCondition«plan.runtimeCondition.id»() {
        super();
        impl = new RunTimeCondition«plan.runtimeCondition.id»Impl();
    }

    public boolean evaluate(RunningPlan rp) {
        «IF (plan.runtimeCondition !== null && plan.runtimeCondition.pluginName == "DefaultPlugin")»
            impl.evaluate(rp)
        «ENDIF»
    }
}
'''

def String runtimeConditionPlanImpl(Plan plan) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.RunningPlan;

public class RunTimeCondition«plan.runtimeCondition.id»Impl {
    public RunTimeCondition«plan.runtimeCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {

    }
}
'''

    def String transitionPreConditionPlan(State state, Transition transition) '''
package de.unikassel.vs.alica.codegen.out;

import de.unikassel.vs.alica.engine.RunningPlan;
import de.unikassel.vs.alica.codegen.out.DomainCondition;

public class PreCondition«transition.preCondition.id» extends DomainCondition {
    private PreCondition«transition.preCondition.id»Impl impl;

    public PreCondition«transition.preCondition.id»() {
        super();
        impl = new PreCondition«transition.preCondition.id»Impl();
    }

    public boolean evaluate(RunningPlan rp) {
        «var List<Transition> outTransitions = state.outTransitions»
        «FOR outTransition: outTransitions»
            «IF (outTransition.preCondition !== null && outTransition.preCondition.pluginName == "DefaultPlugin")»
                impl.evaluate(rp)
            «ENDIF»
        «ENDFOR»
    }
}
'''

def String transitionPreConditionPlanImpl(Transition transition) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.RunningPlan;

public class PreCondition«transition.preCondition.id»Impl {
    public PreCondition«transition.preCondition.id»Impl() {

    }

    public boolean evaluate(RunningPlan rp) {

    }
}
'''

    def String planImpl(Plan plan) '''
package de.unikassel.vs.alica.codegen.out.impl;

import de.unikassel.vs.alica.engine.BasicPlan;
import de.unikassel.vs.alica.engine.BasicUtilityFunction;
import de.unikassel.vs.alica.engine.DefaultUtilityFunction;

public class «StringUtils.capitalize(plan.name)»«plan.id»Impl {
    public BasicUtilityFunction getUtilityFunction(BasicPlan plan) {
        return new DefaultUtilityFunction(plan);
    }
}
'''
}
