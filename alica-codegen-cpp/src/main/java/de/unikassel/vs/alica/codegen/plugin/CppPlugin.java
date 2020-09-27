package de.unikassel.vs.alica.codegen.plugin;

import de.unikassel.vs.alica.codegen.Codegenerator;
import de.unikassel.vs.alica.codegen.CodegeneratorCpp;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerCpp;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;

import java.io.IOException;

public class CppPlugin implements IPlugin {
    @Override
    public Parent getPluginUI() throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(this.getClass().getClassLoader().getResource("ui.fxml"));
        return fxmlLoader.load();
    }

    @Override
    public String getName() {
        return "C++ Plugin";
    }

    @Override
    public Codegenerator getCodeGenerator() {
        return new CodegeneratorCpp();
    }

    @Override
    public GeneratedSourcesManagerCpp getGeneratedSourcesManager() {
        return new GeneratedSourcesManagerCpp();
    }
}
