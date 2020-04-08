package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import de.unikassel.vs.alica.planDesigner.alicamodel.Condition;
import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.PostCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import de.unikassel.vs.alica.planDesigner.alicamodel.RuntimeCondition;
import java.util.List;
import org.apache.commons.lang3.StringUtils;


class XtendTemplates {

    def String behaviourCreator(List<Behaviour> behaviours)'''
from engine import BasicBehaviour
«FOR beh : behaviours»
    «IF (!beh.relativeDirectory.isEmpty)»
        from «beh.relativeDirectory».«StringUtils.lowerCase(beh.name)» import «StringUtils.capitalize(beh.name)»
    «ELSE»
        from «StringUtils.lowerCase(beh.name)» import «StringUtils.capitalize(beh.name)»
    «ENDIF»
«ENDFOR»


class BehaviourCreator(object):
    def create_behaviour(self, behaviour_id: int) -> BasicBehaviour:
        «FOR beh : behaviours»
        if behaviour_id == «beh.id»:
            return «StringUtils.capitalize(beh.name)»()
        «ENDFOR»
        print("BehaviourCreator: Unknown behaviour requested: {}".format(behaviour_id))
'''

    def String utilityFunctionCreator(List<Plan> plans)'''
from engine import BasicUtilityFunction
«FOR p: plans»
    from utility_function_«p.id» import UtilityFunction«p.id»
«ENDFOR»


class UtilityFunctionCreator(object):
    def create_utility(self, utility_function_conf_id: int) -> BasicUtilityFunction:
        «FOR p: plans»
        if utility_function_conf_id == «p.id»:
            return UtilityFunction«p.id»()
        «ENDFOR»
        print("UtilityFunctionCreator: Unknown utility requested: {}".format(utility_function_conf_id))
'''

    def String conditionCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions) '''
from engine import BasicCondition
«FOR con: conditions»
    from pre_condition_«con.id» import PreCondition«con.id»
«ENDFOR»


class ConditionCreator(object):
    def create_conditions(self, condition_conf_id: int) -> BasicCondition:
        «FOR con: conditions»
        if condition_conf_id == «con.id»:
            «IF (con instanceof PreCondition)»
            return PreCondition«con.id»()
            «ENDIF»
            «IF (con instanceof PostCondition)»
            return PostCondition«con.id»()
            «ENDIF»
            «IF (con instanceof RuntimeCondition)»
            return RunTimeCondition«con.id»()
            «ENDIF»
        «ENDFOR»
        print("ConditionCreator: Unknown condition id requested: {}".format(condition_conf_id))
'''

    def String constraintCreator(List<Plan> plans, List<Behaviour> behaviours, List<Condition> conditions)'''
from engine import BasicConstraint


class ConstraintCreator(object):
    def create_constraint(self, constraint_conf_id: int) -> BasicConstraint:
        «FOR c: conditions»
            «IF (c.variables.size > 0) || (c.quantifiers.size > 0)»
                if constraint_conf_id == «c.id»:
                    return Constraint«c.id»()
            «ENDIF»
        «ENDFOR»
        print("ConstraintCreator: Unknown constraint requested: {}".format(constraint_conf_id))
'''

}
