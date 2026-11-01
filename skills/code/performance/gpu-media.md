# GPU & Media Acceleration on Windows

Windows DirectComposition, WinUI 3 Composition APIs, and Direct3D interop.

## 1. Composition API Spring & Implicit Animations

Use the WinUI 3 visual compositor to animate transforms on the compositor thread without stalling the UI thread:

```csharp
using Microsoft.UI.Xaml.Hosting;

public static void ApplyImplicitOffsetAnimation(UIElement element)
{
    var visual = ElementCompositionPreview.GetElementVisual(element);
    var compositor = visual.Compositor;

    var animationGroup = compositor.CreateAnimationGroup();
    var offsetAnimation = compositor.CreateVector3KeyFrameAnimation();
    offsetAnimation.Target = "Offset";
    offsetAnimation.InsertExpressionKeyFrame(1.0f, "this.FinalValue");
    offsetAnimation.Duration = TimeSpan.FromMilliseconds(200);

    animationGroup.Add(offsetAnimation);
    visual.ImplicitAnimations = compositor.CreateImplicitAnimationCollection();
    visual.ImplicitAnimations["Offset"] = animationGroup;
}
```

## 2. Hardware Video Playback

Use `MediaPlayerElement` backed by Windows Media Foundation for GPU-accelerated video rendering.
