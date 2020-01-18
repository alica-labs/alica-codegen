package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.codegen.out.BehaviourCreator;
import de.unikassel.vs.alica.codegen.out.TestfxBehaviour;
import de.unikassel.vs.alica.engine.BasicBehaviour;
import org.junit.Assert;
import org.junit.Test;

public class BehaviourCreatorTest {
    @Test
    public void testCreateExistingBehaviour() throws Exception {
        BehaviourCreator behaviourCreator = new BehaviourCreator();
        BasicBehaviour existingBehaviour = behaviourCreator.createBehaviour(1575724510639L);
        Assert.assertTrue(existingBehaviour instanceof TestfxBehaviour);
    }

    @Test(expected = Exception.class)
    public void testCreateNotExistingBehaviour() throws Exception {
        BehaviourCreator behaviourCreator = new BehaviourCreator();
        BasicBehaviour notExistingBehaviour = behaviourCreator.createBehaviour(0L);
    }
}
