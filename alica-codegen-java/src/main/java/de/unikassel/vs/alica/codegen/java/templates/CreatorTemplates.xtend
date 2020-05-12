package de.unikassel.vs.alica.codegen.java.templates;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.RuntimeCondition;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.ICreatorTemplates;


class CreatorTemplates implements ICreatorTemplates {

    override String behaviourCreator(List<Behaviour> behaviours)'''
package de.uniks.vs.alica.code.gen.creators;

import de.uniks.vs.jalica.engine.BasicBehaviour;
import de.uniks.vs.jalica.engine.IBehaviourCreator;
«FOR beh: behaviours»
    «IF (!beh.relativeDirectory.isEmpty)»
        import de.uniks.vs.alica.code.gen.behaviours.«beh.relativeDirectory».«StringUtils.capitalize(beh.name)»;
     «ELSE»
        import de.uniks.vs.alica.code.gen.behaviours.«StringUtils.capitalize(beh.name)»;
    «ENDIF»
«ENDFOR»

public class BehaviourCreator implements IBehaviourCreator {
    public BasicBehaviour createBehaviour(long behaviourId, Object context) {
        switch (String.valueOf(behaviourId)) {
            «FOR beh: behaviours»
                case "«beh.id»":
                    return new «StringUtils.capitalize(beh.name)»(context);
            «ENDFOR»
            default:
                System.err.println("BehaviourCreator: Unknown behaviour requested: " + behaviourId);
                return null;
        }
    }
}
'''

    override String utilityFunctionCreator(List<Plan> plans)'''
package de.uniks.vs.alica.code.gen.creators;

import de.uniks.vs.jalica.engine.BasicUtilityFunction;
import de.uniks.vs.jalica.engine.IUtilityCreator;
«FOR p: plans»
    «IF (!p.relativeDirectory.isEmpty)»
        import de.uniks.vs.alica.code.gen.utilityfunctions«p.relativeDirectory».UtilityFunction«p.id»;
    «ELSE»
        import de.uniks.vs.alica.code.gen.utilityfunctions.UtilityFunction«p.id»;
    «ENDIF»
«ENDFOR»

public class UtilityFunctionCreator implements IUtilityCreator {
    public BasicUtilityFunction createUtility(long utilityFunctionConfId) {
        switch(String.valueOf(utilityFunctionConfId)) {
            «FOR p: plans»
                case "«p.id»":
                    return new UtilityFunction«p.id»();
            «ENDFOR»
            default:
                System.err.println("UtilityFunctionCreator: Unknown utility requested: " + utilityFunctionConfId);
                return null;
        }
    }
}
'''

    override String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
package de.uniks.vs.alica.code.gen.creators;

import de.uniks.vs.jalica.engine.BasicCondition;
import de.uniks.vs.jalica.engine.IConditionCreator;
«FOR con: conditions»
    import de.uniks.vs.alica.code.gen.conditions.PreCondition«con.id»;
«ENDFOR»

public class ConditionCreator implements IConditionCreator {
    public BasicCondition createConditions(long conditionConfId, Object context) {
        switch (String.valueOf(conditionConfId)) {
            «FOR con: conditions»
                case "«con.id»":
                    «IF (con instanceof PreCondition)»
                        return new PreCondition«con.id»(context);
                    «ENDIF»
                    «IF (con instanceof PostCondition)»
                        return new PostCondition«con.id»(context);
                    «ENDIF»
                    «IF (con instanceof RuntimeCondition)»
                        return new RunTimeCondition«con.id»(context);
                    «ENDIF»
            «ENDFOR»
            default:
                System.err.println("ConditionCreator: Unknown condition id requested: " + conditionConfId);
                return null;
        }
    }
}
'''

    override String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
package de.uniks.vs.alica.code.gen.creators;

import de.uniks.vs.jalica.engine.BasicConstraint;

public class ConstraintCreator {
    public BasicConstraint createConstraint(long constraintConfId, Object context) {
        switch (String.valueOf(constraintConfId)) {
            «FOR c: conditions»
                «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                    case "«c.id»":
                        return new Constraint«c.id»(context);
                «ENDIF»
            «ENDFOR»
            default:
                System.err.println("ConstraintCreator: Unknown constraint requested: " + constraintConfId);
                return null;
        }
    }
}
'''

}
