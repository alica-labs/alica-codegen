package de.unikassel.vs.alica.codegen.plugin;

import de.unikassel.vs.alica.codegen.Codegenerator;
import de.unikassel.vs.alica.codegen.CodegeneratorPython;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerPython;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;

import java.io.IOException;

public class PythonPlugin implements IPlugin {
    @Override
    public Parent getPluginUI() throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(this.getClass().getClassLoader().getResource("ui.fxml"));
        return fxmlLoader.load();
    }

    @Override
    public String getName() {
        return this.getClass().getSimpleName();
    }

    @Override
    public Codegenerator getCodeGenerator() {
        return new CodegeneratorPython();
    }

    @Override
    public GeneratedSourcesManagerPython getGeneratedSourcesManager() {
        return new GeneratedSourcesManagerPython();
    }
}
