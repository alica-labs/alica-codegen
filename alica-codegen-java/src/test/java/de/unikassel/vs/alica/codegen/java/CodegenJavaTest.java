package de.unikassel.vs.alica.codegen.java;

import de.unikassel.vs.alica.codegen.CodegeneratorJava;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerJava;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.junit.BeforeClass;
import org.junit.ClassRule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class CodegenJavaTest {
    private static String tmpPath;

    @ClassRule
    public static TemporaryFolder tmpFolder = new TemporaryFolder();

    @BeforeClass
    public static void beforeClass() throws IOException, InterruptedException {
        tmpPath = tmpFolder.getRoot().getAbsolutePath();

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

    private static void compileCode() throws IOException, InterruptedException {
        // Compiles already generated source code

        List<Path> paths = new ArrayList<>();
        Files.walk(Paths.get(tmpPath))
                .filter(Files::isRegularFile)
                .filter(p -> FilenameUtils.getExtension(p.getFileName().toString()).equals("java"))
                .forEach(paths::add);

        StringBuilder stringBuilder = new StringBuilder();
        for (Path path: paths) {
            if (stringBuilder.length() > 0) {
                stringBuilder.append(" ");
            }
            stringBuilder.append(path.toAbsolutePath().toString());
        }
        String filesStr = stringBuilder.toString();

        String command = "javac " + filesStr;
        Runtime.getRuntime().exec(command).waitFor();
    }

    @Test
    public void testBehaviourCreator() {

    }
}
