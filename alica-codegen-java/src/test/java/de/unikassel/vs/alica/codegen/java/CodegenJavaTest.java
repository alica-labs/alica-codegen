package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.codegen.CodegeneratorJava;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerJava;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
import org.apache.commons.io.FileUtils;
import org.junit.BeforeClass;
import org.junit.ClassRule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class CodegenJavaTest {
    @ClassRule
    public static TemporaryFolder tmpFolder = new TemporaryFolder();

    @BeforeClass
    public static void beforeClass() throws IOException {
        generateCode();
        compileCode();
    }

    private static void generateCode() throws IOException {
        // Generates java source code

        Plan plan = new Plan();
        plan.setMasterPlan(true);
        EntryPoint entryPoint = new EntryPoint();
        plan.addEntryPoint(entryPoint);
        State state = new State();
        TerminalState terminalState = new TerminalState();
        plan.addState(state);
        plan.addState(terminalState);
        Transition transition = new Transition();
        plan.addTransition(transition);
        plan.setDirty(false);
        plan.setRelativeDirectory("");
        plan.setId(1575724499793L);
        plan.setName("testfxPlan");

        List<Plan> plans = new ArrayList<>();
        plans.add(plan);

        Behaviour behaviour = new Behaviour();
        behaviour.setDirty(false);
        behaviour.setRelativeDirectory("");
        behaviour.setId(1575724510639L);
        behaviour.setName("testfxBehaviour");

        List<Behaviour> behaviours = new ArrayList<>();
        behaviours.add(behaviour);

        PreCondition preCondition = new PreCondition();
        preCondition.setEnabled(true);
        preCondition.setPluginName("DefaultPlugin");
        preCondition.setId(1575724578855L);
        preCondition.setName("Precondition1");

        List<Condition> conditions = new ArrayList<>();
        conditions.add(preCondition);

        GeneratedSourcesManagerJava generatedSourcesManager = new GeneratedSourcesManagerJava();
        String tmpPath = tmpFolder.getRoot().getAbsolutePath();
        generatedSourcesManager.setGenSrcPath(tmpPath);
        CodegeneratorJava codegenerator = new CodegeneratorJava(
                plans,
                behaviours,
                conditions,
                tmpPath,
                generatedSourcesManager);
        codegenerator.generate();

        // copy engine folder from resources to destination
        URL url = CodegenJavaTest.class.getResource("engine");
        String path = url.getPath();
        File engineFolderSrc = new File(path);
        File engineFolderDst = new File(tmpPath + File.separator + "de" + File.separator + "unikassel" +
                File.separator + "vs" + File.separator + "alica" + File.separator + "engine");
        FileUtils.copyDirectory(engineFolderSrc, engineFolderDst);
    }

    private static void compileCode() {
        // Compiles already generated source code

    }

    @Test
    public void testBehaviourCreator() {

    }
}
