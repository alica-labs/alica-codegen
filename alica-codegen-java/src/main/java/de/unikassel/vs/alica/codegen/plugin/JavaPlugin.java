package de.unikassel.vs.alica.codegen.plugin;

import de.unikassel.vs.alica.codegen.Codegenerator;
import de.unikassel.vs.alica.codegen.CodegeneratorJava;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManager;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerJava;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;

import java.io.IOException;

public class JavaPlugin implements IPlugin<JavaPlugin> {
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
        return new CodegeneratorJava();
    }

    @Override
    public GeneratedSourcesManager getGeneratedSourcesManager() {
        return new GeneratedSourcesManagerJava();
    }
}
